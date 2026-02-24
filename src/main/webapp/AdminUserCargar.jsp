<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Carga de Usuarios - Control de Almacén</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #001f3f 0%, #0074D9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .dashboard-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px;
            border-radius: 20px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            color: white;
        }

        .dashboard-card h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
            letter-spacing: 1px;
            font-size: 24px;
        }

        /* 🔴 Estilo para Error */
        .alert-error {
            background: rgba(255, 76, 76, 0.2);
            border-left: 5px solid #ff4c4c;
            color: #ffd6d6;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
        }

        /* 🟢 NUEVO: Estilo para Éxito */
        .alert-success {
            background: rgba(46, 204, 113, 0.2);
            border-left: 5px solid #2ecc71;
            color: #d4edda;
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
        }

        .input-group {
            margin-bottom: 15px;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            margin-bottom: 6px;
            font-weight: 500;
            color: #e0e0e0;
        }

        .input-group input,
        .input-group select {
            width: 100%;
            padding: 12px 15px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.9);
            color: #333;
            font-size: 14px;
            outline: none;
            transition: all 0.3s ease;
        }

        .input-group input:focus,
        .input-group select:focus {
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(0, 116, 217, 0.4);
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .btn-primary {
            flex: 2;
            padding: 12px;
            background: #0074D9;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s, transform 0.1s;
            text-align: center;
        }

        .btn-primary:hover {
            background: #0056b3;
        }

        .btn-primary:active {
            transform: scale(0.98);
        }

        .btn-secondary {
            flex: 1;
            padding: 12px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .btn-secondary:active {
            transform: scale(0.98);
        }
    </style>
</head>
<body>

<div class="dashboard-card">
    <h2>Registrar Nuevo Usuario</h2>

    <% String error = (String) request.getAttribute("mensajeError"); %>
    <% if (error != null) { %>
    <div class="alert-error">
        <strong>¡Atención!</strong> <%= error %>
    </div>
    <% } %>

    <% String exito = (String) request.getSession().getAttribute("mensajeExito"); %>
    <% if (exito != null) { %>
    <div class="alert-success">
        <strong>¡Excelente!</strong> <%= exito %>
    </div>
    <%
        // EL TRUCO MAGICO: Borramos el mensaje de la sesión para que no vuelva a salir si recarga la página
        request.getSession().removeAttribute("mensajeExito");
    %>
    <% } %>

    <form action="SvUsuario" method="post">

        <div class="input-group">
            <label>Nombre de usuario:</label>
            <input type="text" name="nomUserNuevo" required
                   value="<%= request.getAttribute("nomGuardado") != null ? request.getAttribute("nomGuardado") : "" %>">
        </div>

        <div class="input-group">
            <label>Contraseña:</label>
            <input type="password" name="contraUserNuevo" required>
        </div>

        <div class="input-group">
            <label>Celular:</label>
            <input type="text" name="celUserNuevo" required
                   value="<%= request.getAttribute("celGuardado") != null ? request.getAttribute("celGuardado") : "" %>">
        </div>

        <div class="input-group">
            <label>Email:</label>
            <input type="email" name="emailUserNuevo" required
                   value="<%= request.getAttribute("emailGuardado") != null ? request.getAttribute("emailGuardado") : "" %>">
        </div>

        <div class="input-group">
            <label>Rol del usuario:</label>
            <select name="rolUser" required>
                <option value="2">Común (Solo almacén)</option>
                <option value="1">Administrador de usuarios</option>
                <option value="13">Administrador de stock</option>
            </select>
        </div>

        <input type="hidden" name="accion" value="cargar">

        <div class="button-group">
            <a href="AdminUser.jsp" class="btn-secondary">Volver</a>
            <button type="submit" class="btn-primary">Registrar Usuario</button>
        </div>

    </form>
</div>

</body>
</html>

<%--    <% String error = (String) request.getAttribute("mensajeError"); %>--%>
<%--    <% if (error != null) { %>--%>
<%--        <div style="background-color: #ffcccc; color: red; padding: 10px; margin-bottom: 15px; border-radius: 5px;">--%>
<%--            <strong>Error:</strong> <%= error %>--%>
<%--        </div>--%>
<%--    <% } %>--%>

<%--    <form action="SvUsuario" method="post">--%>
<%--        <p><label>Nombre usuario: </label><input type="text" name="nomUserNuevo"--%>
<%--                                            value="<%= request.getAttribute("nomGuardado") != null ? request.getAttribute("nomGuardado") : ""  %>">--%>
<%--        </p>--%>
<%--        <p><label>Contraseña: </label><input type="text" name="contraUserNuevo"></p>--%>
<%--        <p><label>Celular: </label><input type="text" name="celUserNuevo"--%>
<%--                                            value="<%= request.getAttribute("celGuardado") != null ? request.getAttribute("celGuardado") : ""%>">--%>
<%--        </p>--%>
<%--        <p><label>Email: </label><input type="text" name="emailUserNuevo"--%>
<%--                                            value="<%= request.getAttribute("emailGuardado") != null ? request.getAttribute("emailGuardado") : "" %>">--%>
<%--        </p>--%>
<%--        <p><label>Rol del usuario: </label>--%>
<%--           <select name="rolUser">--%>
<%--               <option value="2">Comun (Solo almacen)</option>--%>
<%--               <option value="1">Administrador de usuarios</option>--%>
<%--               <option value="13">Administrador de stock</option>--%>
<%--           </select>--%>
<%--        </p>--%>
<%--        <input type="hidden" name="accion" value="cargar">--%>
<%--        <button type="submit">Registrar Usuario</button>--%>
<%--    </form>--%>

<%--    <form action="AdminUser.jsp">--%>
<%--        <button type="submit"><-- Volver</button>--%>
<%--    </form>--%>
