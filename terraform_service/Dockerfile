FROM hashicorp/terraform

WORKDIR /app/

# Copy the scripts and make them executable
COPY ./docker-entrypoint ./setup ./setup_auto ./open ./open_auto ./
RUN chmod +x ./docker-entrypoint ./setup ./setup_auto ./open ./open_auto

#Allows us to do `docker compose exec terraform setup` rather than `docker compose exec terraform ./setup`, which looks slightly cleaner
ENV PATH=$PATH:/app

ENTRYPOINT ["./docker-entrypoint"]
