"use strict"

import express from 'express'
import cors from 'cors'

import path from 'path'
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

//Deconstruct environment variables with sensible defaults
const {
  DB_USERNAME = "postgres",
  DB_PASSWORD = "seacret_bassword",
  DB_HOST, //No default, because we only use a real database if this is set.
  DB_PORT = 5432,
  APP_PORT = 80,
  APP_HOST = "0.0.0.0",
  SECRET_ID = "whale-secret",
  AWS_REGION = "eu-west-1"
} = process.env

// initialise Secrets Manager client - aws sdk v3
import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";
const client = new SecretsManagerClient({ region: AWS_REGION });
const command = new GetSecretValueCommand({ SecretId: SECRET_ID }); //Make this an env var

/**
 * Data Access Object Configuration
 */
let dao

if (DB_HOST) {
  dao = (await import('./databaseDao.js')).default

  dao.configure({
    user:     DB_USERNAME,
    password: DB_PASSWORD,
    host:     DB_HOST,
    port:     DB_PORT
  })
} else {
  dao = (await import('./memoryDao.js')).default
}

/**
 * Express App Configuration
 */
let app

function configureEndpoints(app)
{
  app.get("/", async (req, res) => {
    console.log("GET /")
    res.sendFile(path.join(__dirname, '/index.html'));
  })

  app.post("/whales", async (req, res) => {
    console.log("POST /whales")
    const whale = req.body.whale_name
    await dao.addWhale(whale)
    res.send(whale)
  })

  app.get("/whales", async (req, res) => {
    console.log("GET /whales")
    const whales = await dao.getAllWhales()
    res.send(whales)
  })

  app.get("/secret", async (req, res) => {
    console.log("GET /secret")
    const secret = await getSecret()
    res.send(secret)
  })

  //TODO - add a "list buckets" & show image in a bucket button.
}

async function getSecret() {
  try {
    const awsResponse = await client.send(command);
    return awsResponse.SecretString
  } catch (error) {
    console.error(error);
    return `Error requesting secrets from AWS: ${error.message}`;
  }
}

async function startServer() {
  //Start DAO (Data Access Object)
  await dao.start()

  // App
  app = express()
  app.use(cors())
  app.use(express.json())

  configureEndpoints(app)

  app.listen(APP_PORT, APP_HOST)
  console.info(`Listening on port ${APP_PORT}`)

  process.on("SIGINT", handleShutdown)
  process.on("SIGTERM", handleShutdown)
  process.on("SIGHUP", handleShutdown)
}

async function handleShutdown() {
  await dao.stop()

  console.info("Exiting")
  process.exit(0)
}

startServer()
