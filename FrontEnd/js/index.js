document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('RegisterUser').addEventListener('submit', async(e)=>{
        e.preventDefault();

        const cc = document.getElementById('dbcc').value;
        const nombre = document.getElementById('dbname').value;
        const apellido = document.getElementById('dbsurname').value;
        const genero = document.getElementById('dbgenre').value;
        const edad = document.getElementById('dbage').value;

        const respuesta = await fetch('http://127.0.0.1:3000/reUser', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({cc, nombre, apellido, genero, edad})
        });
        if(respuesta.ok){
            Swal.fire({
                    title: "User Registrado",
                    text: "Los datos se guardaron el base de datos",
                    icon: "success",
                    draggable: true,
                    confirmButtonText:'OK'
                });
        }
        else{
            Swal.fire({
                    text: "Hubo problemas al Registrar",
                    icon: "error",
                    draggable: true,
                    confirmButtonText:'Intentar de nuevo'
                });
        }
    });
    document.getElementById('ObtenerIMC').addEventListener('submit', async (e) => {
        e.preventDefault();

        const cc = document.getElementById('updcc').value;
        const peso = document.getElementById('updpeso').value;
        const estatura = document.getElementById('updestatura').value;
        try {
            await fetch('http://127.0.0.1:3000/upImc', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({cc, peso, estatura})
        })
        .then(res => res.json()) 
        .then(data => {
            Swal.fire({
                    title: `User ${data[0].nombre} Tiene un IMC de ${data[0].imc}`,
                    text: `Clasificacion: ${data[0].clasificacion}`,
                    draggable: true,
                    confirmButtonText:'OK'
                });
        })
        } catch (error) {
            Swal.fire({
                    text: "Oops, Revisa Los datos",
                    icon: 'error',
                    draggable: true,
                    confirmButtonText:'Intentar de nuevo'
                });
        }
    })
})