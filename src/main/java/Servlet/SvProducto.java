package Servlet;

import back.ControladoraLogica;
import back.Producto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SvProducto", urlPatterns = {"/SvProducto"})
public class SvProducto extends HttpServlet {

    ControladoraLogica controladoraLogica = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        switch (accion) {

            case "agregarProd":
                String marca = req.getParameter("marca");
                String tipo = req.getParameter("tipo");
                String precio = req.getParameter("precio").replace(",", ".");
                String stock = req.getParameter("stock");
                double precioConver = 0.0;
                int stockConver = 0;
                try {
                    precioConver = Double.parseDouble(precio);
                } catch (Exception e) {
                    req.setAttribute("mensajeError", "En el precio debe ingresar NUMEROS");
                    req.setAttribute("marca", marca);
                    req.setAttribute("tipo", tipo);
                    req.setAttribute("precio", precio);
                    req.setAttribute("stock", stock);
                    req.getRequestDispatcher("AdminCargaProducto.jsp").forward(req, resp);
                    return;
                }

                try {
                    stockConver = Integer.parseInt(stock);
                } catch (Exception e) {
                    req.setAttribute("mensajeError", "En el stock debe ingresar NUMEROS ENTEROS");
                    req.setAttribute("marca", marca);
                    req.setAttribute("tipo", tipo);
                    req.setAttribute("precio", precio);
                    req.setAttribute("stock", stock);
                    req.getRequestDispatcher("AdminCargaProducto.jsp").forward(req, resp);
                    return;
                }

                Producto productoNuevo = new Producto();
                productoNuevo.setMarca(marca);
                productoNuevo.setPrecio(precioConver);
                productoNuevo.setStock(stockConver);
                productoNuevo.setTipoProd(tipo);
                boolean activo = true;
                productoNuevo.setActivo(activo);
                controladoraLogica.crearProducto(productoNuevo);

                req.getSession().setAttribute("mensajeExito", "Producto Registrado Correctamente");
                resp.sendRedirect("AdminCargaProducto.jsp");
                break;

            case "darBajaProd":
                int idBaja = Integer.parseInt(req.getParameter("idProdBaja"));
                Producto productoBaja = controladoraLogica.buscarProducto(idBaja);
                productoBaja.setActivo(false);
                controladoraLogica.modificarProducto(productoBaja);
                req.getSession().setAttribute("mensajeExito", "Producto dado de baja Correctamente");
                resp.sendRedirect("TablaProductos.jsp");
                break;

            case "modProd":
                String precioMod = req.getParameter("precioMod").replace(",", ".");
                String stockMod = req.getParameter("stockMod");
                String tipoMod = req.getParameter("tipoMod");
                String marcaMod = req.getParameter("marcaMod");
                int idModProd = Integer.parseInt(req.getParameter("idProdMod"));
                double precioModConv = 0.0;
                int stockModConv = 0;
                Producto productoMod = controladoraLogica.buscarProducto(idModProd);
                try {
                    precioModConv = Double.parseDouble(precioMod);
                } catch (Exception e) {
                    req.setAttribute("mensajeError", "En el precio debe ingresar NUMEROS");
                    req.setAttribute("marca", marcaMod);
                    req.setAttribute("tipo", tipoMod);
                    req.setAttribute("precio", precioMod);
                    req.setAttribute("stock", stockMod);

                    req.setAttribute("productoMod", productoMod);

                    req.getRequestDispatcher("AdminProdMod.jsp").forward(req, resp);
                    return;
                }

                try {
                    stockModConv = Integer.parseInt(stockMod);
                } catch (Exception e) {
                    req.setAttribute("mensajeError", "En el stock debe ingresar NUMEROS ENTEROS");
                    req.setAttribute("marca", marcaMod);
                    req.setAttribute("tipo", tipoMod);
                    req.setAttribute("precio", precioMod);
                    req.setAttribute("stock", stockMod);

                    req.setAttribute("productoMod", productoMod);

                    req.getRequestDispatcher("AdminProdMod.jsp").forward(req, resp);
                    return;
                }

                productoMod.setStock(stockModConv);
                productoMod.setPrecio(precioModConv);
                productoMod.setMarca(marcaMod);
                productoMod.setTipoProd(tipoMod);
                controladoraLogica.modificarProducto(productoMod);
                req.getSession().setAttribute("mensajeExito", "Producto Modificado Correctamente");
                resp.sendRedirect("TablaProductos.jsp");
                break;

            case "actuStock":
                int idActuStockProd = Integer.parseInt(req.getParameter("idActuStockProd"));
                String stockActu = req.getParameter("nuevoStock");
                Producto productoActuStock = controladoraLogica.buscarProducto(idActuStockProd);
                int stockActuConver = 0;
                try {
                    stockActuConver = Integer.parseInt(stockActu);
                }
                catch (Exception e) {
                    req.setAttribute("mensajeError", "El stock debe tener NUMEROS ENTEROS");
                    req.setAttribute("stock", stockActu);
                    req.setAttribute("productoActuStock", productoActuStock);
                    req.getRequestDispatcher("AdminProdStock.jsp").forward(req, resp);
                    return;
                }
                int nuevoStockActualizado = productoActuStock.getStock() + stockActuConver;
                productoActuStock.setStock(nuevoStockActualizado);
                controladoraLogica.modificarProducto(productoActuStock);
                req.getSession().setAttribute("mensajeExito", "Stock actualizado Correctamente");
                resp.sendRedirect("TablaProductos.jsp");
                break;



        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        switch (accion) {

            case "modProd":
                int idMod = Integer.parseInt(req.getParameter("idProdMod"));
                Producto productoMod = controladoraLogica.buscarProducto(idMod);
                req.setAttribute("productoMod", productoMod);
                req.getRequestDispatcher("AdminProdMod.jsp").forward(req, resp);
                break;
            case "actuStock":
                int idActuStock = Integer.parseInt(req.getParameter("idActuStock"));
                Producto productoActuStock = controladoraLogica.buscarProducto(idActuStock);
                req.setAttribute("productoActuStock", productoActuStock);
                req.getRequestDispatcher("AdminProdStock.jsp").forward(req, resp);
                break;
        }

    }
}
