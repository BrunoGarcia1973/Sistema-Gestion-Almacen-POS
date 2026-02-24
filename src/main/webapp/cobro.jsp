<%@ page import="back.Venta" %>
<%@ page import="back.DetalleVenta" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ticket de Cobro</title>
    <style>
        /* --- ESTILOS DE LA PANTALLA DEL CAJERO --- */
        body {
            background: #001f3f; /* Azul oscuro facherito de tu sistema */
            font-family: 'Courier New', Courier, monospace; /* Letra de maquinita */
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
            color: #000;
        }

        /* --- ESTILOS DEL PAPEL (Simulando 80mm) --- */
        .ticket-papel {
            background: white;
            width: 320px; /* Ancho estándar de ticketera */
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            border-radius: 5px;
        }

        /* Cabecera y Logo */
        .header-ticket {
            text-align: center;
            border-bottom: 2px dashed #000;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }

        .header-ticket img {
            width: 60px; /* Tamaño del logo para que no ocupe todo el papel */
            height: auto;
            margin-bottom: 5px;
        }

        .header-ticket h2 { margin: 0; font-size: 18px; }
        .header-ticket p { margin: 3px 0; font-size: 12px; }

        /* Datos de la venta (Fecha y Número) */
        .datos-venta {
            font-size: 12px;
            margin-bottom: 10px;
            border-bottom: 2px dashed #000;
            padding-bottom: 10px;
        }

        /* Tabla de los productos */
        table { width: 100%; border-collapse: collapse; font-size: 12px; }
        th { text-align: left; border-bottom: 1px solid #000; padding-bottom: 3px; }
        td { padding: 4px 0; vertical-align: top; }
        .col-precio { text-align: right; font-weight: bold; }

        /* El Total gigante */
        .total-seccion {
            margin-top: 10px;
            border-top: 2px dashed #000;
            padding-top: 10px;
            font-size: 18px;
            font-weight: bold;
            text-align: right;
        }

        .footer-ticket { text-align: center; margin-top: 20px; font-size: 12px; }

        /* Botón gigante para volver al mostrador */
        .btn-volver {
            margin-top: 20px;
            padding: 12px 25px;
            background: #2ecc71;
            color: white;
            text-decoration: none;
            font-family: 'Segoe UI', sans-serif;
            font-weight: bold;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
            transition: 0.2s;
        }
        .btn-volver:hover { background: #27ae60; }

        /* --- MAGIA PURA: ESTO SE ACTIVA SOLO AL IMPRIMIR --- */
        @media print {
            body { background: white; padding: 0; align-items: flex-start; }
            .ticket-papel { box-shadow: none; width: 100%; margin: 0; padding: 0; border-radius: 0; }
            .btn-volver { display: none !important; } /* Oculta el botón verde en el papel */
        }
    </style>
</head>
<body>

<%
    // Atrapamos el "ticket" de tu Servlet
    Venta venta = (Venta) request.getSession().getAttribute("ticket");

    // Formateador de fechas para que quede linda en el papel
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    // Para mostrar con dos decimales
    DecimalFormat df = new DecimalFormat("#.00");
%>

<div class="ticket-papel">

    <div class="header-ticket">
        <img src="https://images.squarespace-cdn.com/content/v1/682e13017021427e489ac9ef/26d73eab-19a7-45d2-bde1-7dd8bd7e5243/Grey+Beard+Communications+Inc_Logo_no+words.jpg" alt="Logo">
        <h2>ALMACÉN CHUNCHULA</h2>
        <p>Comprobante de Venta</p>
        <p>No válido como factura</p>
    </div>

    <div class="datos-venta">
        <p style="margin: 0;"><strong>Fecha:</strong> <%= sdf.format(venta.getFechaVenta()) %></p>
        <p style="margin: 0;"><strong>Ticket Nro:</strong> <%= venta.getIdVenta() %></p>
    </div>

    <table>
        <thead>
        <tr>
            <th>Cant</th>
            <th>Detalle</th>
            <th class="col-precio">Subt</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (DetalleVenta detalleVenta : venta.getListaDetalles()) {
        %>
        <tr>
            <td><%=detalleVenta.getCant()%></td>
            <td>
                <%=detalleVenta.getProducto().getMarca()%> <%=detalleVenta.getProducto().getTipoProd()%><br>
                <small>($<%=detalleVenta.getProducto().getPrecio()%> c/u)</small>
            </td>
            <td class="col-precio">$<%=detalleVenta.getSubTotal()%></td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <div class="total-seccion">
        <%
            // Atrapamos si es Mercado Pago o Efectivo
            Boolean esMP = (Boolean) request.getSession().getAttribute("esMP");

            if (esMP != null && esMP) {
                // Si es MP, calculamos cuánto es el recargo y el total final del cliente
                double recargo = venta.getTotalVenta() * 0.0411;
                double totalFinalCliente = venta.getTotalVenta() * 1.0411;
        %>
        <div style="font-size: 14px; font-weight: normal; margin-bottom: 5px; text-align: right;">
            Subtotal: $<%= df.format(venta.getTotalVenta()) %><br>
            Comisión MP (3.95%): $<%= df.format(recargo) %>
        </div>
        TOTAL A PAGAR: $<%= df.format(totalFinalCliente) %>
        <% } else { %>
        TOTAL: $<%= df.format(venta.getTotalVenta()) %>
        <% } %>
    </div>

    <div class="footer-ticket">
        <p>¡Gracias por su compra!</p>
    </div>

</div>

<a href="AdminAlmacen.jsp" class="btn-volver">Volver a la Caja</a>

<script>
    window.onload = function() {
        // Le damos medio segundo de tiempo para que cargue la foto del logo antes de mandar a imprimir
        setTimeout(function() {
            window.print();
        }, 500);
    };
</script>

</body>
</html>

<%--    <%--%>
<%--        Venta venta = (Venta) request.getSession().getAttribute("ticket");--%>
<%--    %>--%>
<%--        <p>Total: <%=venta.getTotalVenta()%></p>--%>
<%--        <p>Fecha: <%=venta.getFechaVenta()%></p>--%>
<%--    <%--%>
<%--        for (DetalleVenta detalleVenta : venta.getListaDetalles()) {--%>
<%--    %>--%>
<%--            <p>Tipo Producto: <%=detalleVenta.getProducto().getTipoProd()%></p>--%>
<%--            <p>Marca Producto: <%=detalleVenta.getProducto().getMarca()%></p>--%>
<%--            <p>Precio Unitario:<%=detalleVenta.getProducto().getPrecio()%></p>--%>
<%--            <p>Cantidad: <%=detalleVenta.getCant()%></p>--%>
<%--            <p>Sub Total: <%=detalleVenta.getSubTotal()%></p>--%>
<%--    <%} %>--%>
