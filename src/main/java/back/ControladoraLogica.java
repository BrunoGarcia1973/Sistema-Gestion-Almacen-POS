package back;

import persistencia.ControladoraPersistencia;
import persistencia.VentaJpaController;

import java.util.ArrayList;

public class ControladoraLogica {
    ControladoraPersistencia controladoraPersistencia = new ControladoraPersistencia();

    // --------------------------------USUARIO--------------------------------
    public void crearUser(Usuario usuario) {
        controladoraPersistencia.crearUser(usuario);
    }

    public void modificarUser(Usuario usuario) {
        controladoraPersistencia.modificarUser(usuario);
    }

    public Usuario buscarUser(int id) {
        return controladoraPersistencia.buscarUser(id);
    }

    public void eliminarUser(int id) {
        controladoraPersistencia.eliminarUser(id);
    }

    public ArrayList<Usuario> traerTodosUser() {
        return controladoraPersistencia.traerTodosUser();
    }

    //--------------------------------ROL--------------------------------
    public void crearRol(Rol rol) {
        controladoraPersistencia.crearRol(rol);
    }

    public void modificarRol(Rol rol) {
        controladoraPersistencia.modificarRol(rol);
    }

    public Rol buscarRol(int id) {
        return controladoraPersistencia.buscarRol(id);
    }

    public void eliminarRol(int id) {
        controladoraPersistencia.eliminarRol(id);
    }

    // --------------------------------PRODUCTO--------------------------------
    public void crearProducto(Producto producto) {
        controladoraPersistencia.crearProducto(producto);
    }

    public void modificarProducto(Producto producto) {
        controladoraPersistencia.modificarProducto(producto);
    }

    public Producto buscarProducto(int id) {
        return controladoraPersistencia.buscarProducto(id);
    }

    public ArrayList<Producto> traerTodosProductos() {
        return controladoraPersistencia.traerTodosProductos();
    }

    //--------------------------------VENTA--------------------------------
    public void crearVenta(Venta venta) {
        controladoraPersistencia.crearVenta(venta);
    }

    public void modificarVenta(Venta venta) {
        controladoraPersistencia.modificarVenta(venta);
    }

    public Venta buscarVenta(int id) {
        return controladoraPersistencia.buscarVenta(id);
    }

    public ArrayList<Venta> traerTodasVentas() {
        return controladoraPersistencia.traerTodasVentas();
    }

    //--------------------------------DETALLE VENTA--------------------------------
    public void crearDetalleVenta(DetalleVenta detalleVenta) {
        controladoraPersistencia.crearDetalleVenta(detalleVenta);
    }

    public void modificarDetalleVenta(DetalleVenta detalleVenta) {
        controladoraPersistencia.modificarDetalleVenta(detalleVenta);
    }

    public DetalleVenta buscarDetalleVenta(int id) {
        return controladoraPersistencia.buscarDetalleVenta(id);
    }

    public ArrayList<DetalleVenta> traerTodasDetallesVentas() {
        return controladoraPersistencia.traerTodasDetallesVentas();
    }

}
