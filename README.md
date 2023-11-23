# Skiller Whale AWS Exercise Repository

## Example Setup Instructions

- Ensure you have the latest version of this `https://github.com/skiller-whale/aws.git` git repository.
- Replace the contents of the `attendance_id` file in this repo, so that it just
  contains your unique id for the session.
- Open a terminal in the `aws` directory.
- In the terminal, run `docker compose up --build` (DO NOT use `-d`, because you need to see the logs).
  This will start syncing any changes you make to the exercise files and obtain AWS credentials for you.
- In the logs, you should see an `AWS console link`
- Copy the `AWS console link` out of the logs, and open it in a browser.
- Open a second terminal in the `aws` directory, and run `docker compose exec terraform setup YOUR_MODULE_KEY`.
  This will apply some initial setup to the account, and open a shell you can use if you need to apply Terraform.
- Open a third terminal in the `aws` directory, and run `docker compose run aws-cli`.
  This will open a shell you can use if you need to run AWS CLI commands.
