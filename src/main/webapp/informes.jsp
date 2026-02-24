<%@ page import="back.DetalleVenta" %>
<%@ page import="back.ControladoraLogica" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="back.Venta" %>
<%@ page import="java.util.Date" %>
<%@ page import="back.Producto" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<html>
<head>
    <title>Panel de Informes | Administrador</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #0b2545; color: #333; padding: 30px; }

        /* Contenedor principal */
        .dashboard-container { max-width: 1200px; margin: 0 auto; }

        /* Encabezado */
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; color: white; }
        .btn-volver { background: #2ecc71; color: white; padding: 10px 20px; text-decoration: none; border-radius: 8px; font-weight: bold; transition: 0.2s; }
        .btn-volver:hover { background: #27ae60; }

        /* Tarjetas de Resumen (KPIs) */
        .kpi-row { display: flex; gap: 20px; margin-bottom: 40px; }
        .kpi-card { background: white; flex: 1; padding: 25px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); display: flex; align-items: center; justify-content: space-between; border-left: 6px solid #009ee3; }
        .kpi-card.green { border-left-color: #2ecc71; }
        .kpi-info h3 { font-size: 16px; color: #7f8c8d; margin-bottom: 5px; text-transform: uppercase; }
        .kpi-info h1 { font-size: 32px; color: #2c3e50; }
        .kpi-icon { font-size: 40px; color: #bdc3c7; opacity: 0.5; }

        /* Sección de Stock */
        .section-title { color: white; margin-bottom: 15px; font-size: 22px; display: flex; align-items: center; gap: 10px; }
        .table-container { background: white; border-radius: 15px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f1f2f6; text-align: left; padding: 15px; color: #2f3542; border-bottom: 2px solid #dfe4ea; }
        td { padding: 15px; border-bottom: 1px solid #f1f2f6; color: #57606f; font-size: 16px; }
        tr:hover { background-color: #f8f9fa; }

        /* Etiqueta de Alerta */
        .badge-danger { background: #ff4757; color: white; padding: 5px 10px; border-radius: 20px; font-weight: bold; font-size: 14px; }
        .badge-warning { background: #ffa502; color: white; padding: 5px 10px; border-radius: 20px; font-weight: bold; font-size: 14px; }
    </style>
</head>
<body>

<%
    ControladoraLogica controladoraLogica = new ControladoraLogica();
    ArrayList<Venta> listaVenta = controladoraLogica.traerTodasVentas();
    double recaudacion = 0.0;
    int contador = 0;

    // Usamos SimpleDateFormat para conseguir la fecha exacta de "hoy" (ej: 22/02/2026)
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String fechaHoyStr = sdf.format(new Date());

    for (Venta venta : listaVenta) {
        if(venta.getFechaVenta() != null) {
            String fechaVentaStr = sdf.format(venta.getFechaVenta());
            if (fechaVentaStr.equals(fechaHoyStr)) {
                contador++;
                recaudacion += venta.getTotalVenta();
            }
        }
    }

    // Limpiamos la recaudación de decimales feos
    double recaudacionLimpia = Math.round(recaudacion * 100.0) / 100.0;

    // Le ponemos el traje de plata argentina (puntos y comas)
    NumberFormat formatoPlata = NumberFormat.getInstance(new Locale("es", "AR"));
    formatoPlata.setMinimumFractionDigits(2);
    formatoPlata.setMaximumFractionDigits(2);
    String recaudacionVisual = formatoPlata.format(recaudacionLimpia);
%>

<div class="dashboard-container">
    <div class="header">
        <div>
            <h1><i class="fa-solid fa-chart-line"></i> Panel de Administración</h1>
            <p style="color: #a4b0be; margin-top: 5px;">Resumen de actividad del día: <%= fechaHoyStr %></p>
        </div>
        <a href="AdminStock.jsp" class="btn-volver"><i class="fa-solid fa-cart-arrow-down"></i> Volver al Menú</a>
    </div>

    <div class="kpi-row">
        <div class="kpi-card">
            <div class="kpi-info">
                <h3>Recaudación de Hoy</h3>
                <h1>$ <%= recaudacionVisual %></h1>
            </div>
            <div class="kpi-icon"><i class="fa-solid fa-hand-holding-dollar"></i></div>
        </div>

        <div class="kpi-card green">
            <div class="kpi-info">
                <h3>Ventas de Hoy</h3>
                <h1><%= contador %> <span style="font-size: 16px; color: #7f8c8d;">tickets</span></h1>
            </div>
            <div class="kpi-icon"><i class="fa-solid fa-receipt"></i></div>
        </div>
    </div>

    <h2 class="section-title"><i class="fa-solid fa-triangle-exclamation" style="color: #ffa502;"></i> Productos en Alerta (Stock Bajo)</h2>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Producto</th>
                <th>Categoría / Tipo</th>
                <th>Stock Actual</th>
                <th>Estado</th>
            </tr>
            </thead>
            <tbody>
            <%
                ArrayList<Producto> listaProductos = controladoraLogica.traerTodosProductos();
                boolean hayAlertas = false;
                for (Producto producto : listaProductos) {
                    if (producto.getStock() < 15 && producto.isActivo()) {
                        hayAlertas = true;
            %>
            <tr>
                <td style="font-weight: bold; color: #2f3542;"><%= producto.getMarca() %></td>
                <td><%= producto.getTipoProd() %></td>
                <td><span style="font-size: 18px; font-weight: bold;"><%= producto.getStock() %></span> unid.</td>
                <td>
                    <% if(producto.getStock() <= 5) { %>
                    <span class="badge-danger">¡Crítico!</span>
                    <% } else { %>
                    <span class="badge-warning">Reponer pronto</span>
                    <% } %>
                </td>
            </tr>
            <%
                    } // fin if
                } // fin for

                // Si el for termina y no hubo ninguno con stock bajo, mostramos este mensaje
                if (!hayAlertas) {
            %>
            <tr>
                <td colspan="4" style="text-align: center; color: #2ecc71; font-weight: bold; padding: 30px;">
                    <i class="fa-solid fa-circle-check" style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
                    ¡Todo perfecto! No hay productos con stock bajo.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>


<%--    <%--%>
<%--      ControladoraLogica controladoraLogica = new ControladoraLogica();--%>
<%--      ArrayList<Venta> listaVenta = controladoraLogica.traerTodasVentas();--%>
<%--      double recaudacion = 0.0;--%>
<%--      int contador = 0;--%>
<%--      for (Venta venta : listaVenta) {--%>
<%--        if (venta.getFechaVenta().getDay() == new Date().getDay()) {--%>
<%--          contador++;--%>
<%--          recaudacion = recaudacion + venta.getTotalVenta();--%>
<%--        }--%>
<%--      }--%>
<%--    %>--%>

<%--    <p>Total recaudado hoy: <%=recaudacion%></p>--%>
<%--    <p>Total de Ventas hoy: <%=contador%></p>--%>

<%--  <%--%>
<%--    ArrayList<Producto> listaProductos = controladoraLogica.traerTodosProductos();--%>
<%--    for (Producto producto : listaProductos) {--%>
<%--      if (producto.getStock() < 15 && producto.isActivo()) {--%>


<%--  %>--%>

<%--    <p>Producto con menos de 15 unidades: <%=producto.getMarca() + "|" + producto.getTipoProd()%></p>--%>
<%--    <p>Cantidad: <%=producto.getStock()%></p>--%>

<%--    <%}%>--%>

<%--<%}%>--%>
