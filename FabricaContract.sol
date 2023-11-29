// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract FabricaContract {
    uint idDigits = 16;

    struct Producto {
        string name;
        uint Id;
    }

    Producto[] public productos;
    mapping(uint => address) public productoAPropietario;
    mapping(address => uint) public propietarioProductos;

    function crearProducto(string memory _nombre, uint _id) private {
        productos.push(Producto(_nombre, _id));
    }

    function _generarIdAleatorio(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % (10**idDigits);
    }

    function crearProductoAleatorio(string memory _nombre) public {
        uint randId = _generarIdAleatorio(_nombre);
        crearProducto(_nombre, randId);
    }

    event NuevoProducto(uint indexed ArrayProductoId, string name, uint id);

    function Propiedad(uint productoId) public {
        productoAPropietario[productoId] = msg.sender;
        propietarioProductos[msg.sender]++;
    }

    function getProductosPorPropietario(address _propietario) external view returns (uint[] memory) {
        uint[] memory resultado = new uint[](propietarioProductos[_propietario]);
        uint contador = 0;
        for (uint i = 0; i < productos.length; i++) {
            if (productoAPropietario[i] == _propietario) {
                resultado[contador] = productos[i].Id;
                contador++;
            }
        }
        return resultado;
    }
}
