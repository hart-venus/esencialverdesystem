let recoleccioncontainer = document.getElementsByClassName('recoleccion-container')[0];
let entregacontainer = document.getElementsByClassName('entrega-container')[0];
let addEntregaButton = document.getElementById('addEntregaButton');
let addRecoleccionButton = document.getElementById('addRecoleccionButton');

function addRecoleccion() {
    // clone the recoleccion container
    let newRecoleccion = recoleccioncontainer.cloneNode(true);
    // add as a sibling, just before the addRecoleccionButton
    recoleccioncontainer.parentNode.insertBefore(newRecoleccion, addRecoleccionButton);
}

function addEntrega() {
    // clone the entrega container
    let newEntrega = entregacontainer.cloneNode(true);
    // add as a sibling, just before the addEntregaButton
    entregacontainer.parentNode.insertBefore(newEntrega, addEntregaButton);
}
