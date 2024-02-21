# Write out a skeleton aws credential file

import sys
import os
import logging
import requests

def allocate_aws_account(attendance_id):
    """Make an api call that will allocate an AWS account and return temporary credentials and a console login link."""

    url = f'https://train.skillerwhale.com/aws/attendances/{attendance_id}/account_allocations'
    response = requests.post(url)

    match response.status_code:
        case 200:
            # Expected response object format::
            #  {
            #   "account_allocation": {
            #     "console_link": "https://signin.aws.amazon.com/federation...",
            #     "aws_account_number": "1122334455",
            #     "credentials": {
            #       "access_key_id": "ASIAEXAMPLE",
            #       "secret_access_key": "EXAMPLE7BrW4wAi9np7mK1",
            #       "session_token":  "a long token"
            #     },
            #   },
            #  "session": {
            #     "module_keys": ["some_curriculum/module_1", "some_curriculum/module_2"]
            #   }
            # }
            return response.json()
        case 403:
            logging.error('Error getting AWS credentials - This can happen if you run setup more than 15 minutes before a session, or if you have not set the correct attendance ID. Check your attendance id is correct, or wait until closer to the session time, then run `docker compose up --build` again.')
            return False
        case _: # This may happen if we've run out of accounts to allocate.
            logging.error('Server error getting credentials: %s - please try again later or contact Skiller Whale for support.', response.reason)
            return False


def write_credentials_to_file(credentials, base_dir):
    """
    Write credentials and config to files in the .aws directory

    The .aws directory should be mounted as a volume and shared with the service that is using the credentials.
    """

    # Set up variables
    aws_access_key_id = credentials['access_key_id']
    aws_secret_access_key = credentials['secret_access_key']
    aws_session_token = credentials['session_token']

    AWS_REGION = 'eu-west-1'
    AWS_OUTPUT = 'json'

    credential_location = os.path.join(base_dir, 'credentials')
    config_location = os.path.join(base_dir, 'config')

    # Write out the credential file
    try:
        with open(credential_location, 'w') as f:
            f.write('[default]\n')
            f.write(f'aws_access_key_id = {aws_access_key_id}\n')
            f.write(f'aws_secret_access_key = {aws_secret_access_key}\n')
            f.write(f'aws_session_token = {aws_session_token}\n')
    except Exception as e:
        logging.error('Error writing out credential file: %s', e)
        return False

    logging.info('Credential file written out successfully')

    # Write out the config file
    try:
        with open(config_location, 'w') as f:
            f.write('[default]\n')
            f.write(f'region = {AWS_REGION}\n')
            f.write(f'output = {AWS_OUTPUT}\n')
    except Exception as e:
        logging.error('Error writing out config file: %s', e)
        return False

    logging.info('Config file written out successfully')

    return True

def write_module_key_to_file(account_allocation_response, session_info_dir, attendance_id):

    # Create the attendance_id directory - using the attendance_id as the directory name to prevent reuse of old module keys that would hang around in the volume.
    attendance_id_dir = os.path.join(session_info_dir, attendance_id)
    os.makedirs(attendance_id_dir, exist_ok=True)

    session = account_allocation_response.get('session', {})
    module_keys = session.get('module_keys', [])

    if len(module_keys) > 1:
        logging.warning(
            """This session consists of multiple modules - the terminal for %s will be started automatically.
               For the others (%s), you will need to open a separate terminal and run:
               docker compose exec terraform setup <module_key>""",
               module_keys[0],
               ', '.join(module_keys[1:])
        )
    elif len(module_keys) < 1:
        logging.warning('No module key found - you will need to enter the module key manually.')
        return False

    # Strip the module key out of "curriculum_key/module_key" format
    module_key = module_keys[0].split('/')[1]

    module_key_file = os.path.join(attendance_id_dir, 'sw_module_key')

    try:
        with open(module_key_file, 'w') as f:
            f.write(module_key)
    except Exception as e:
        logging.error('Error writing out module key file: %s', e)
        return False

    logging.info('Module key file written out successfully')

    return True

def main(base_dir='/root'):
    # TODO - implement a watch on the attendance id file, so that we can re-run this script if the attendance id changes.

    # Set up logging
    logging.basicConfig(level=logging.INFO)

    # Read the attendance id from the file
    try:
        with open('./attendance_id', 'r') as f:
            attendance_id = f.read().strip()
    except Exception as e:
        logging.error('Error reading attendance id file: %s', e)
        return False

    # Check if the attendance id is still the default.
    if attendance_id == 'your_attendance_id_here':
        logging.error('Could not find attendance id in attendance_id file. Please add your attendance id to the file and try again.')
        return False

    # Make api call to allocate an account and get credentials.
    account_allocation_response  = allocate_aws_account(attendance_id)

    account_allocation = account_allocation_response['account_allocation']

    if not account_allocation:
        return False

    logging.info("""Account allocated successfully.
                    Account ID: %s
                    AWS console link: %s""",
                    account_allocation["aws_account_number"],
                    account_allocation["console_link"])

    # Write the credentials (and config) to files.
    aws_base_dir = os.path.join(base_dir, '.aws')
    write_credentials_success = write_credentials_to_file(account_allocation['credentials'], aws_base_dir)

    # Get the module keys and write the first one to file. If there is more than one, warn the user.
    session_info_base_dir = os.path.join(base_dir, '.session_info')
    write_module_key_success = write_module_key_to_file(account_allocation_response, session_info_base_dir, attendance_id)

    return write_credentials_success and write_module_key_success

if __name__ == '__main__':
    if main():
        sys.exit(0)
    else:
        sys.exit(1)
