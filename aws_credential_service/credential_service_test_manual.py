import responses
import credential_service

# You can run this test locally if you have Python > 3.10 and responses installed, and an attendance id file
# or you can modify the Dockerfile to install responses and run it with docker compose up --build

BASE_DIRECTORY = '/root' # /root if you're running this in Docker, /. if you want to run it locally
API_URL = 'https://train.skillerwhale.com/aws/attendances/test-attendance-id/account_allocations'

SUCCESSFUL_ACCOUNT_ALLOCATION = {
  "console_link": "https://signin.aws.amazon.com/federation...",
  "aws_account_number": "1122334455",
  "credentials": {
    "access_key_id": "add_here_for_testing",
    "secret_access_key": "add_here_for_testing",
    "session_token":  "add_here_for_testing"
  }
}


@responses.activate
def test_success():
    responses.add(responses.POST, API_URL,
                json={
      "account_allocation": SUCCESSFUL_ACCOUNT_ALLOCATION,
      "session": {
        "module_keys": ["ec2/introduction_to_vpc"]
      }
    }, status=200)

    assert credential_service.main(BASE_DIRECTORY)

@responses.activate
def test_forbidden():
    responses.add(responses.POST, API_URL, status=403)

    assert not credential_service.main(BASE_DIRECTORY)

@responses.activate
def test_500():
    responses.add(responses.POST, API_URL, status=500)

    assert not credential_service.main(BASE_DIRECTORY)

@responses.activate
def test_no_module_keys():
    responses.add(responses.POST, API_URL,
                json={
      "account_allocation": SUCCESSFUL_ACCOUNT_ALLOCATION
    }, status=200)

    # This should fail, because there are no module keys.
    assert not credential_service.main(BASE_DIRECTORY)

@responses.activate
def test_multiple_module_keys():
    responses.add(responses.POST, API_URL,
                json={
      "account_allocation": SUCCESSFUL_ACCOUNT_ALLOCATION,
      "session": {
        "module_keys": ["ec2/launching_instances", "ec2/security_groups_and_acls"]
      }
    }, status=200)

    # This should work, but generate a warning.
    assert credential_service.main(BASE_DIRECTORY)

if __name__ == '__main__':
    # test_success()
    # test_no_module_keys()
    test_multiple_module_keys()
    # test_forbidden()
    # test_500()
