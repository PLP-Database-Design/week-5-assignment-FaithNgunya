const express = require('express');
const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// MySQL connection configuration
const connection = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

connection.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL database!');
});

// 1. Retrieve all patients
app.get('/patients', (req, res) => {
    connection.query('SELECT patient_id, first_name, last_name, date_of_birth FROM patients', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// 2. Retrieve all providers
app.get('/providers', (req, res) => {
    connection.query('SELECT first_name, last_name, provider_specialty FROM providers', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// 3. Filter patients by First Name
app.get('/patients/:firstName', (req, res) => {
    const firstName = req.params.firstName;
    connection.query('SELECT patient_id, first_name, last_name, date_of_birth FROM patients WHERE first_name = ?', [firstName], (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// 4. Retrieve all providers by their specialty
app.get('/providers/:specialty', (req, res) => {
    const specialty = req.params.specialty;
    connection.query('SELECT first_name, last_name, provider_specialty FROM providers WHERE provider_specialty = ?', [specialty], (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});