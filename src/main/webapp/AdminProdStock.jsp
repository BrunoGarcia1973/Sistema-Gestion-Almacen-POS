<%@ page import="back.Producto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Stock - Control de Almacén</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        /* Reset básico */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        /* Fondo general del sistema */
        body {
            background: linear-gradient(135deg, #001f3f 0%, #0074D9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Contenedor estilo tarjeta de vidrio */
        .form-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px;
            border-radius: 20px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            color: white;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
            font-size: 24px;
            letter-spacing: 1px;
        }

        /* Cajita resumen del producto (Para que sepa a qué le suma stock) */
        .producto-resumen {
            background: rgba(0, 0, 0, 0.2);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .producto-resumen p {
            margin-bottom: 5px;
            font-size: 14px;
            color: #d1d8e0;
        }

        .producto-resumen span {
            font-weight: 600;
            color: white;
        }

        /* Cartel de Error */
        .alert-error {
            background-color: rgba(231, 76, 60, 0.2);
            border: 1px solid #e74c3c;
            color: #ffcccc;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 500;
            font-size: 14px;
        }

        /* Estilos del input */
        .input-group {
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 15px;
            font-weight: 500;
            color: #80c4ff;
        }

        .input-group input {
            width: 100%;
            padding: 12px 15px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
            color: white;
            font-size: 16px; /* Letra un poco más grande para el número */
            outline: none;
            transition: all 0.3s;
            text-align: center; /* Centramos el número para que quede facha */
        }

        .input-group input:focus {
            border-color: #0074D9;
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 0 10px rgba(0, 116, 217, 0.3);
        }

        /* Botones */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-submit {
            flex: 2;
            background: #3498db; /* Azulito para la carga de stock */
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-submit:hover { background: #2980b9; }

        .btn-volver {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding: 12px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-volver:hover { background: rgba(255, 255, 255, 0.2); }

    </style>
</head>
<body>

<div class="form-container">
    <h2>📦 Ingreso de Mercadería</h2>

    <%-- Rescatamos el objeto que mandó el Servlet --%>
    <% Producto producto = (Producto) request.getAttribute("productoActuStock"); %>

    <%-- ATAJAMOS EL MENSAJE DE ERROR --%>
    <%
        String mensajeError = (String) request.getAttribute("mensajeError");
        if (mensajeError != null) {
    %>
    <div class="alert-error">
        ⚠️ <%= mensajeError %>
    </div>
    <% } %>

    <div class="producto-resumen">
        <p>Tipo: <span><%=producto.getTipoProd()%></span></p>
        <p>Marca: <span><%=producto.getMarca()%></span></p>
        <p>Precio Unitario: <span>$<%=producto.getPrecio()%></span></p>
        <p>Stock Actual: <span style="color: #2ecc71;"><%=producto.getStock()%> unid.</span></p>
    </div>

    <form action="SvProducto" method="post">

        <div class="input-group">
            <label>➕ Cantidad que ingresa al almacén:</label>
            <input type="text" name="nuevoStock" value="<%= request.getAttribute("stock") != null ? request.getAttribute("stock") : ""%>" placeholder="Ej: 50" required>
        </div>

        <input type="hidden" name="accion" value="actuStock">
        <input type="hidden" name="idActuStockProd" value="<%=producto.getIdProducto()%>">

        <div class="button-group">
            <a href="TablaProductos.jsp" class="btn-volver">⬅ Volver</a>
            <button type="submit" class="btn-submit">Sumar Stock</button>
        </div>

    </form>
</div>

</body>
</html>

<%--    <%--%>
<%--        Producto producto = (Producto) request.getAttribute("productoActuStock");--%>
<%--    %>--%>

<%--    <form action="SvProducto" method="post">--%>
<%--        <p>Tipo Producto: <%=producto.getTipoProd()%></p>--%>
<%--        <p>Marca Producto: <%=producto.getMarca()%></p>--%>
<%--        <p>Precio: <%=producto.getPrecio()%></p>--%>
<%--        <p><label>Ingrese la nueva cantidad que entro: </label> <input type="text" name="nuevoStock"--%>
<%--                                                                       value="<%= request.getAttribute("stock") != null ? request.getAttribute("stock") : ""%>">--%>
<%--        </p>--%>
<%--        <input type="hidden" name="accion" value="actuStock">--%>
<%--        <input type="hidden" name="idActuStockProd" value="<%=producto.getIdProducto()%>">--%>
<%--        <button type="submit">Actualizar Stock</button>--%>
<%--    </form>--%>

<%--    <form action="TablaProductos.jsp">--%>
<%--        <button type="submit"> <-- Volver</button>--%>
<%--    </form>--%>
