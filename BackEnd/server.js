const express = require("express");
const cors = require("cors");
const pool = require("./db.js");

const app = express();
const PORT = 3000;
app.use(cors({origin:'http://127.0.0.1:5500'}))
app.use(express.json());


app.post('/reUser', (req, res)=>{
    const {cc, nombre, apellido, genero, edad} = req.body;
    pool.query('INSERT INTO USERS (CC,NOMBRE,APELLIDO,GENERO,EDAD) VALUES ($1,$2,$3,$4,$5);', [cc, nombre, apellido, genero, edad], (err, resultado)=>{
        if (err) return res.status(500).json(err);
        res.status(200).json({ mensaje: "User Registrado correctamente" });
    })
});

app.post('/upImc', (req, res)=>{
    const {cc, peso, estatura} = req.body;
    pool.query('SELECT * FROM  f_imc_client($1,$2,$3) AS RESULTADO;', [cc, peso, estatura], (err, resultado)=>{
        if (err) return res.status(500).json(err);
        res.status(200).json(resultado.rows);
    })
});

app.listen(PORT, () => {
    console.log(`Servidor Corriendo en http://localhost:${PORT}`);
});