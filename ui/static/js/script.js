let recoleccioncontainer = document.getElementsByClassName('recoleccion-container')[0];
let entregacontainer = document.getElementsByClassName('entrega-container')[0];
let addEntregaButton = document.getElementById('addEntregaButton');
let addRecoleccionButton = document.getElementById('addRecoleccionButton');


// hide recoleccion container and entrega container
recoleccioncontainer.style.display = 'none';
entregacontainer.style.display = 'none';

function addRecoleccion() {
    // clone the recoleccion container
    let newRecoleccion = recoleccioncontainer.cloneNode(true);
    // make the new recoleccion container visible
    newRecoleccion.style.display = 'block';
    // add as a sibling, just before the addRecoleccionButton
    recoleccioncontainer.parentNode.insertBefore(newRecoleccion, addRecoleccionButton);
}

function addEntrega() {
    // clone the entrega container
    let newEntrega = entregacontainer.cloneNode(true);
    // make the new entrega container visible
    newEntrega.style.display = 'block';
    // add as a sibling, just before the addEntregaButton
    entregacontainer.parentNode.insertBefore(newEntrega, addEntregaButton);
}

function deleteParent(element) {
    element.parentNode.remove();
}

