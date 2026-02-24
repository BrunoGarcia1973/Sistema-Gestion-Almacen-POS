package Servlet;

import back.ControladoraLogica;
import back.DetalleVenta;
import back.Producto;
import back.Venta;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;

@WebServlet(name = "SvCarro", urlPatterns = {"/SvCarro"})
public class SvCarro extends HttpServlet {

    ControladoraLogica controladoraLogica = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        switch (accion) {
            case "agregar":

                HttpSession session = req.getSession();
                ArrayList<DetalleVenta> carrito = (ArrayList<DetalleVenta>) session.getAttribute("carrito");
                if (carrito == null) {
                    carrito = new ArrayList<>();
                    session.setAttribute("carrito", carrito);
                }

                int cant = 0;
                int idProdAgregar = Integer.parseInt(req.getParameter("idProdAgregar"));
                try {
                    cant = Integer.parseInt(req.getParameter("cant"));
                    if (cant <= 0) {
                        req.setAttribute("mensajeError", "La cantidad debe ser mayor a cero.");
                        req.getRequestDispatcher("AdminAlmacen.jsp").forward(req, resp);
                        return;
                    }
                } catch (Exception e) {
                    req.setAttribute("mensajeError", "La cantidad debe ser un NUMERO ENTERO");
                    req.getRequestDispatcher("AdminAlmacen.jsp").forward(req, resp);
                    return;
                }

                // 1. BUSQUEDA DEL PRODUCTO EN LA BASE DE DATOS
                Producto productoAgregar = controladoraLogica.buscarProducto(idProdAgregar);

                // 2. MAGIA NUEVA: Nos fijamos si el producto ya está en el changuito
                int cantidadYaEnCarrito = 0;
                for (DetalleVenta dv : carrito) {
                    if (dv.getProducto().getIdProducto() == idProdAgregar) {
                        cantidadYaEnCarrito = dv.getCant();
                        break; // Lo encontramos, cortamos la búsqueda
                    }
                }

                // 3. NUEVA VALIDACIÓN BLINDADA (Lo que pide + lo que ya tiene vs Stock)
                if ((cant + cantidadYaEnCarrito) > productoAgregar.getStock()) {
                    int stockDisponibleParaAgregar = productoAgregar.getStock() - cantidadYaEnCarrito;
                    String mensaje = "¡Sin stock suficiente! ";

                    // Hacemos que el error sea inteligente
                    if (cantidadYaEnCarrito > 0) {
                        mensaje += "Ya tenés " + cantidadYaEnCarrito + " en el carrito. Solo podés agregar " + stockDisponibleParaAgregar + " unidades más de " + productoAgregar.getMarca() + ".";
                    } else {
                        mensaje += "Solo quedan " + productoAgregar.getStock() + " unidades de " + productoAgregar.getMarca() + " en total.";
                    }

                    req.setAttribute("mensajeError", mensaje);
                    req.getRequestDispatcher("AdminAlmacen.jsp").forward(req, resp);
                    return;
                }

                // 4. SI PASÓ LA VALIDACIÓN, AGREGAMOS NORMALMENTE (Tu código original)
                if (!carrito.isEmpty()) {
                    for (DetalleVenta detalleVenta : carrito) {
                        if (detalleVenta.getProducto().getIdProducto() == idProdAgregar) {
                            int cantNueva = detalleVenta.getCant() + cant;
                            detalleVenta.setCant(cantNueva);
                            double subTotalNuevoCrudo = detalleVenta.getCant() * detalleVenta.getProducto().getPrecio();
                            double subTotalNuevoLimpio = Math.round(subTotalNuevoCrudo * 100.0) / 100.0;
                            detalleVenta.setSubTotal(subTotalNuevoLimpio);
                            resp.sendRedirect("AdminAlmacen.jsp");
                            return;
                        }
                    }
                }

                DetalleVenta detalleVenta = new DetalleVenta();
                detalleVenta.setCant(cant);
                double subTotalCrudo = cant * productoAgregar.getPrecio();
                double subTotalLimpio = Math.round(subTotalCrudo * 100.0) / 100.0;
                detalleVenta.setSubTotal(subTotalLimpio);
                detalleVenta.setProducto(productoAgregar);
                carrito.add(detalleVenta);

                resp.sendRedirect("AdminAlmacen.jsp");
                break;

//                HttpSession session = req.getSession();
//                ArrayList<DetalleVenta> carrito = (ArrayList<DetalleVenta>) session.getAttribute("carrito");
//                if (carrito == null) {
//                    carrito = new ArrayList<>();
//                    session.setAttribute("carrito", carrito);
//                }
//                int cant = 0;
//                int idProdAgregar = Integer.parseInt(req.getParameter("idProdAgregar"));
//                try {
//                    cant = Integer.parseInt(req.getParameter("cant"));
//                    if (cant <= 0) {
//                        req.setAttribute("mensajeError", "La cantidad debe ser mayor a cero.");
//                        req.getRequestDispatcher("AdminAlmacen.jsp").forward(req, resp);
//                        return;
//                    }
//                } catch (Exception e) {
//                    req.setAttribute("mensajeError", "La cantidad debe ser un NUMERO ENTERO");
//                    req.getRequestDispatcher("AdminAlmacen.jsp").forward(req, resp);
//                    return;
//                }
//
//                // BUSQUEDA DEL PRODUCTO
//                Producto productoAgregar = controladoraLogica.buscarProducto(idProdAgregar);
//
//                if (cant > productoAgregar.getStock()) {
//                    req.setAttribute("mensajeError", "¡Sin stock suficiente! Solo quedan " + productoAgregar.getStock() + " unidades de " + productoAgregar.getMarca() + ".");
//                    req.getRequestDispatcher("AdminAlmacen.jsp").forward(req, resp);
//                    return;
//                }
//
//                if (!carrito.isEmpty()) {
//                    for (DetalleVenta detalleVenta : carrito) {
//                        if (detalleVenta.getProducto().getIdProducto() == idProdAgregar) {
//                            int cantNueva = detalleVenta.getCant() + cant;
//                            detalleVenta.setCant(cantNueva);
//                            double subTotalNuevoCrudo = detalleVenta.getCant() * detalleVenta.getProducto().getPrecio();
//                            double subTotalNuevoLimpio = Math.round(subTotalNuevoCrudo * 100.0) / 100.0;
//                            detalleVenta.setSubTotal(subTotalNuevoLimpio);
//                            resp.sendRedirect("AdminAlmacen.jsp");
//                            return;
//                        }
//                    }
//                }
//                DetalleVenta detalleVenta = new DetalleVenta();
//                detalleVenta.setCant(cant);
//                double subTotalCrudo = cant * productoAgregar.getPrecio();
//                double subTotalLimpio = Math.round(subTotalCrudo * 100.0) / 100.0;
//                detalleVenta.setSubTotal(subTotalLimpio);
//                detalleVenta.setProducto(productoAgregar);
//                carrito.add(detalleVenta);
//                resp.sendRedirect("AdminAlmacen.jsp");
//                break;

            case "eliminarCarro":
                int idDetalleBorrar = Integer.parseInt(req.getParameter("idDetalleEli"));
                ArrayList<DetalleVenta> carritoEliminar = (ArrayList<DetalleVenta>) req.getSession().getAttribute("carrito");
                for (DetalleVenta detalleVenta1 : carritoEliminar) {
                    if (detalleVenta1.getProducto().getIdProducto() == idDetalleBorrar) {
                        carritoEliminar.remove(detalleVenta1);
                        resp.sendRedirect("AdminAlmacen.jsp");
                        return;
                    }
                }
                break;
            case "descontarCarro":
                int idProdDesco = Integer.parseInt(req.getParameter("idDetalleDesco"));
                ArrayList<DetalleVenta> listaDetalleDescontar = (ArrayList<DetalleVenta>) req.getSession().getAttribute("carrito");
                for (DetalleVenta detalleVenta1 : listaDetalleDescontar) {
                    if (detalleVenta1.getProducto().getIdProducto() == idProdDesco) {
                        int cantNueva = detalleVenta1.getCant() - 1;
                        if (cantNueva == 0) {
                            listaDetalleDescontar.remove(detalleVenta1);
                            resp.sendRedirect("AdminAlmacen.jsp");
                            return;
                        }
                        else {
                            detalleVenta1.setCant(cantNueva);
                            double subTotalNuevoCrudo = detalleVenta1.getCant() * detalleVenta1.getProducto().getPrecio();
                            double subTotalNuevoLimpio = Math.round(subTotalNuevoCrudo * 100.0) / 100.0;
                            detalleVenta1.setSubTotal(subTotalNuevoLimpio);
                            resp.sendRedirect("AdminAlmacen.jsp");
                            return;
                        }

                    }
                }
                break;
            case "cobrar":

                // 1. Preguntamos con qué pagaron
                String metodoPago = req.getParameter("metodoPago");
                boolean esMP = "MP".equals(metodoPago);

                ArrayList<DetalleVenta> detalleVentasListaFinal = (ArrayList<DetalleVenta>) req.getSession().getAttribute("carrito");
                Venta venta = new Venta();
                venta.setFechaVenta(new Date());
                double totalFinal = 0.0;

                for (DetalleVenta detalleVenta1 : detalleVentasListaFinal) {
                    totalFinal = totalFinal + detalleVenta1.getSubTotal();
                }
                double totalFinalLimpio = Math.round(totalFinal * 100.0) / 100.0;

                // 2. Guardamos tu ganancia LIMPIA en la BD
                venta.setTotalVenta(totalFinalLimpio);
                controladoraLogica.crearVenta(venta);

                for (DetalleVenta detalleVenta1 : detalleVentasListaFinal) {
                    Producto producto = detalleVenta1.getProducto();
                    int stockFinal  = producto.getStock() - detalleVenta1.getCant();
                    producto.setStock(stockFinal);
                    controladoraLogica.modificarProducto(producto);
                    detalleVenta1.setVenta(venta);
                    controladoraLogica.crearDetalleVenta(detalleVenta1);
                }

                venta.setListaDetalles(detalleVentasListaFinal);
                req.getSession().setAttribute("ticket", venta);

                // 3. MAGIA: Le pasamos al ticket de papel si tiene que dibujar o no el recargo
                req.getSession().setAttribute("esMP", esMP);

                req.getSession().removeAttribute("carrito");
                resp.sendRedirect("cobro.jsp");
                break;

//                ArrayList<DetalleVenta> detalleVentasListaFinal = (ArrayList<DetalleVenta>) req.getSession().getAttribute("carrito");
//                Venta venta = new Venta();
//                venta.setFechaVenta(new Date());
//                double totalFinal = 0.0;
//                for (DetalleVenta detalleVenta1 : detalleVentasListaFinal) {
//                    totalFinal = totalFinal + detalleVenta1.getSubTotal();
//                }
//                double totalFinalLimpio = Math.round(totalFinal * 100.0) / 100.0;
//                venta.setTotalVenta(totalFinalLimpio);
//                controladoraLogica.crearVenta(venta);
//                for (DetalleVenta detalleVenta1 : detalleVentasListaFinal) {
//                    Producto producto = detalleVenta1.getProducto();
//                    int stockFinal  = producto.getStock() - detalleVenta1.getCant();
//                    producto.setStock(stockFinal);
//                    controladoraLogica.modificarProducto(producto);
//                    detalleVenta1.setVenta(venta);
//                    controladoraLogica.crearDetalleVenta(detalleVenta1);
//                }
//                venta.setListaDetalles(detalleVentasListaFinal);
//                req.getSession().setAttribute("ticket", venta);
//                req.getSession().removeAttribute("carrito");
//                resp.sendRedirect("cobro.jsp");


        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    }
}
