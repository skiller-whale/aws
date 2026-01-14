To push a new image for this:

- ensure your AWS CLI is logged in with sso and a shared_res profile configured for the Shared Resources account with enough permissions
- Open a terminal in the whale_server_code directory
- Run the command:
     `aws ecr get-login-password --profile=shared_res | docker login --username AWS --password-stdin 058264400233.dkr.ecr.eu-west-1.amazonaws.com`

- Open a terminal in the `whale_server_code` directory and build the image with:
    `docker build -t 058264400233.dkr.ecr.eu-west-1.amazonaws.com/whale_server .`
- Push the image with:
    `docker push 058264400233.dkr.ecr.eu-west-1.amazonaws.com/whale_server`
