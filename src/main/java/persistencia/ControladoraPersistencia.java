package persistencia;

import back.*;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.ArrayList;
import java.util.List;

public class ControladoraPersistencia {

    // MAGIA NIVEL DIOS: Creamos UNA SOLA fábrica estática para toda la aplicación.
    // OJO ACA: Tenés que poner el nombre exacto de tu Unidad de Persistencia (Persistence Unit)
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("almacen");

    // Ahora, a todos los controladores les pasamos la misma fábrica (emf) por el constructor
    RolJpaController rolJpaController = new RolJpaController(emf);
    UsuarioJpaController usuarioJpaController = new UsuarioJpaController(emf);
    ProductoJpaController productoJpaController = new ProductoJpaController(emf);
    VentaJpaController ventaJpaController = new VentaJpaController(emf);
    DetalleVentaJpaController detalleVentaJpaController = new DetalleVentaJpaController(emf);

    //--------------------------------USUARIO--------------------------------
    public void crearUser(Usuario usuario) {
        usuarioJpaController.create(usuario);
    }

    public void modificarUser(Usuario usuario) {
        try {
            usuarioJpaController.edit(usuario);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Usuario buscarUser(int id) {
        return usuarioJpaController.findUsuario(id);
    }

    public void eliminarUser(int id) {
        usuarioJpaController.destroy(id);
    }

    public ArrayList<Usuario> traerTodosUser() {
        List<Usuario> lista = usuarioJpaController.findUsuarioEntities();
        ArrayList<Usuario> listaUser = new ArrayList<>(lista);
        return listaUser;
    }

    // --------------------------------ROL--------------------------------
    public void crearRol(Rol rol) {
        rolJpaController.create(rol);
    }

    public void modificarRol(Rol rol) {
        try {
            rolJpaController.edit(rol);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Rol buscarRol(int id) {
        return rolJpaController.findRol(id);
    }

    public void eliminarRol(int id) {
        rolJpaController.destroy(id);
    }

    // --------------------------------PRODUCTO--------------------------------
    public void crearProducto(Producto producto) {
        productoJpaController.create(producto);
    }


    public void modificarProducto(Producto producto) {
        try {
            productoJpaController.edit(producto);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Producto buscarProducto(int id) {
        return productoJpaController.findProducto(id);
    }

    public ArrayList<Producto> traerTodosProductos() {
        List<Producto> lista = productoJpaController.findProductoEntities();
        ArrayList<Producto> listaProd = new ArrayList<>(lista);
        return listaProd;
    }

    //--------------------------------VENTA--------------------------------
    public void crearVenta(Venta venta) {
        ventaJpaController.create(venta);
    }

    public void modificarVenta(Venta venta) {
        try {
            ventaJpaController.edit(venta);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Venta buscarVenta(int id) {
        return ventaJpaController.findVenta(id);
    }

    public ArrayList<Venta> traerTodasVentas() {
        List<Venta> lista = ventaJpaController.findVentaEntities();
        ArrayList<Venta> listaVenta = new ArrayList<>(lista);
        return listaVenta;
    }

    //--------------------------------DETALLE VENTA--------------------------------
    public void crearDetalleVenta(DetalleVenta detalleVenta) {
        detalleVentaJpaController.create(detalleVenta);
    }

    public void modificarDetalleVenta(DetalleVenta detalleVenta) {
        try {
            detalleVentaJpaController.edit(detalleVenta);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public DetalleVenta buscarDetalleVenta(int id) {
        return detalleVentaJpaController.findDetalleVenta(id);
    }

    public ArrayList<DetalleVenta> traerTodasDetallesVentas() {
        List<DetalleVenta> lista = detalleVentaJpaController.findDetalleVentaEntities();
        ArrayList<DetalleVenta> listaDetalleVenta = new ArrayList<>(lista);
        return listaDetalleVenta;
    }
}
