let recoleccioncontainer = document.getElementsByClassName('recoleccion-container')[0];
let entregacontainer = document.getElementsByClassName('entrega-container')[0];


function addRecoleccion() {
    // clone the recoleccion container
    let newRecoleccion = recoleccioncontainer.cloneNode(true);
    // add as a sibling of the recoleccion container
    recoleccioncontainer.parentNode.insertBefore(newRecoleccion, recoleccioncontainer.nextSibling);
}

function addEntrega() {
    // clone the entrega container
    let newEntrega = entregacontainer.cloneNode(true);
    // add as a sibling of the entrega container
    entregacontainer.parentNode.insertBefore(newEntrega, entregacontainer.nextSibling);
}
