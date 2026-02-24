<%@ page import="back.Producto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Modificar Producto - Control de Almacén</title>

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
            margin-bottom: 25px;
            font-weight: 600;
            font-size: 24px;
            letter-spacing: 1px;
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

        /* Estilos de los inputs */
        .input-group {
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
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
            font-size: 14px;
            outline: none;
            transition: all 0.3s;
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
            background: #f39c12; /* Naranja para la modificación */
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-submit:hover { background: #d68910; }

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
    <h2>✏️ Editar Producto</h2>

    <%-- Rescatamos el objeto que mandó el Servlet --%>
    <% Producto producto = (Producto) request.getAttribute("productoMod"); %>

    <%-- ATAJAMOS EL MENSAJE DE ERROR --%>
    <%
        String mensajeError = (String) request.getAttribute("mensajeError");
        if (mensajeError != null) {
    %>
    <div class="alert-error">
        ⚠️ <%= mensajeError %>
    </div>
    <% } %>

    <form action="SvProducto" method="post">

        <div class="input-group">
            <label>Tipo / Descripción:</label>
            <input type="text" name="tipoMod" value="<%= request.getAttribute("tipo") != null ? request.getAttribute("tipo") : producto.getTipoProd()%>" required>
        </div>

        <div class="input-group">
            <label>Marca del Producto:</label>
            <input type="text" name="marcaMod" value="<%= request.getAttribute("marca") != null ? request.getAttribute("marca") : producto.getMarca()%>" required>
        </div>

        <div class="input-group">
            <label>Precio Unitario ($):</label>
            <input type="text" name="precioMod" value="<%= request.getAttribute("precio") != null ? request.getAttribute("precio") : producto.getPrecio()%>" required>
        </div>

        <div class="input-group">
            <label>Stock Actual:</label>
            <input type="text" name="stockMod" value="<%= request.getAttribute("stock") != null ? request.getAttribute("stock") : producto.getStock()%>" required>
        </div>

        <input type="hidden" name="accion" value="modProd">
        <input type="hidden" name="idProdMod" value="<%= producto.getIdProducto() %>">

        <div class="button-group">
            <a href="TablaProductos.jsp" class="btn-volver">⬅ Volver</a>
            <button type="submit" class="btn-submit">Guardar Cambios</button>
        </div>

    </form>
</div>

</body>
</html>

<%--    <%--%>
<%--        Producto producto = (Producto) request.getAttribute("productoMod");--%>
<%--    %>--%>

<%--    <form action="SvProducto" method="post">--%>
<%--        <p><label>Tipo Producto: </label><input type="text" name="tipoMod"--%>
<%--                                                value="<%= request.getAttribute("tipo") != null ? request.getAttribute("tipo") : producto.getTipoProd()%>">--%>
<%--        </p>--%>
<%--        <p><label>Marca Producto: </label><input type="text" name="marcaMod"--%>
<%--                                                 value="<%= request.getAttribute("marca") != null ? request.getAttribute("marca") : producto.getMarca()%>">--%>
<%--        </p>--%>
<%--        <p><label>Precio: </label><input type="text" name="precioMod"--%>
<%--                                         value="<%= request.getAttribute("precio") != null ? request.getAttribute("precio") : producto.getPrecio()%>">--%>
<%--        </p>--%>
<%--        <p><label>Stock: </label><input type="text" name="stockMod"--%>
<%--                                        value="<%= request.getAttribute("stock") != null ? request.getAttribute("stock") : producto.getStock()%>">--%>
<%--        </p>--%>
<%--        <input type="hidden" name="accion" value="modProd">--%>
<%--        <input type="hidden" name="idProdMod" value="<%=producto.getIdProducto()%>">--%>
<%--        <button>Confirmar Modificacion</button>--%>
<%--    </form>--%>

<%--    <form action="TablaProductos.jsp">--%>
<%--        <button type="submit"><-- Volver</button>--%>
<%--    </form>--%>
