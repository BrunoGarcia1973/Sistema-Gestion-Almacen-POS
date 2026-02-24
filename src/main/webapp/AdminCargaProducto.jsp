<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Carga de Productos - Control de Almacén</title>

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

        /* Carteles de Mensajes */
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

        .alert-success {
            background-color: rgba(46, 204, 113, 0.2);
            border: 1px solid #2ecc71;
            color: #a9dfbf;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 500;
            font-size: 14px;
            transition: opacity 0.5s ease;
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
            background: #28a745;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-submit:hover { background: #218838; }

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
    <h2>📦 Cargar Producto</h2>

    <%-- 1. ATAJAMOS EL MENSAJE DE ÉXITO DE LA SESIÓN --%>
    <%
        String mensajeExito = (String) session.getAttribute("mensajeExito");
        if (mensajeExito != null) {
    %>
    <div id="cartel-exito" class="alert-success">
        ✅ <%= mensajeExito %>
    </div>
    <script>
        setTimeout(function() {
            let cartel = document.getElementById('cartel-exito');
            if (cartel) {
                cartel.style.opacity = '0';
                setTimeout(function() { cartel.style.display = 'none'; }, 500);
            }
        }, 3000);
    </script>
    <%
            session.removeAttribute("mensajeExito");
        }
    %>

    <%-- 2. ATAJAMOS EL MENSAJE DE ERROR DEL REQUEST --%>
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
            <label>Marca del Producto:</label>
            <input type="text" name="marca" value="<%= request.getAttribute("marca") != null ? request.getAttribute("marca") : "" %>" required>
        </div>

        <div class="input-group">
            <label>Tipo / Descripción:</label>
            <input type="text" name="tipo" value="<%= request.getAttribute("tipo") != null ? request.getAttribute("tipo") : "" %>" required>
        </div>

        <div class="input-group">
            <label>Precio Unitario ($):</label>
            <input type="text" name="precio" value="<%= request.getAttribute("precio") != null ? request.getAttribute("precio") : "" %>" required>
        </div>

        <div class="input-group">
            <label>Stock Inicial:</label>
            <input type="text" name="stock" value="<%= request.getAttribute("stock") != null ? request.getAttribute("stock") : "" %>" required>
        </div>

        <input type="hidden" name="accion" value="agregarProd">

        <div class="button-group">
            <a href="AdminStock.jsp" class="btn-volver">⬅ Volver</a>
            <button type="submit" class="btn-submit">Registrar Producto</button>
        </div>

    </form>
</div>

</body>
</html>

<%--    <form action="SvProducto" method="post">--%>
<%--        <p><label>Marca del Producto: </label><input type="text" name="marca"--%>
<%--                                        value="<%= request.getAttribute("marca") != null ? request.getAttribute("marca") : "" %>">--%>
<%--        </p>--%>
<%--        <p><label>Tipo Producto: </label><input type="text" name="tipo"--%>
<%--                                       value="<%= request.getAttribute("tipo") != null ? request.getAttribute("tipo") : "" %>">--%>
<%--        </p>--%>
<%--        <p><label>Precio: </label><input type="text" name="precio"--%>
<%--                                         value="<%= request.getAttribute("precio") != null ? request.getAttribute("precio") : "" %>">--%>
<%--        </p>--%>
<%--        <p><label>Stock: </label><input type="text" name="stock"--%>
<%--                                        value="<%= request.getAttribute("stock") != null ? request.getAttribute("stock") : "" %>">--%>
<%--        </p>--%>
<%--        <input type="hidden" name="accion" value="agregarProd">--%>
<%--        <button type="submit">Registrar Producto</button>--%>
<%--    </form>--%>

<%--    <form action="AdminStock.jsp">--%>
<%--        <button type="submit"><-- Volver</button>--%>
<%--    </form>--%>

