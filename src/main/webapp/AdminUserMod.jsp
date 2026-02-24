<%@ page import="back.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Modificación de Usuario - Control de Almacén</title>

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

        .input-group input, .input-group select {
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

        .input-group input:focus, .input-group select:focus {
            border-color: #0074D9;
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 0 10px rgba(0, 116, 217, 0.3);
        }

        /* Truco para que las opciones del select se vean bien (ya que no soportan transparencia) */
        .input-group select option {
            background: #001f3f;
            color: white;
        }

        /* Botones */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-submit {
            flex: 2; /* Ocupa más espacio */
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
            flex: 1; /* Ocupa menos espacio */
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

<% Usuario usuario = (Usuario) request.getAttribute("usuarioMod"); %>

<div class="form-container">
    <h2>Editar Perfil</h2>

    <%-- ACÁ ATAJAMOS EL MENSAJE DE ERROR DEL SERVLET --%>
    <%
        String mensajeError = (String) request.getAttribute("mensajeError");
        if (mensajeError != null) {
    %>
    <div class="alert-error">
        ⚠️ <%= mensajeError %>
    </div>
    <% } %>

    <form action="SvUsuario" method="post">

        <div class="input-group">
            <label>Nombre Usuario:</label>
            <input type="text" name="nomMod" value="<%=request.getAttribute("nombreUserMod") != null ? request.getAttribute("nombreUserMod") : usuario.getNombreUser()%>" required>
        </div>

        <div class="input-group">
            <label>Email:</label>
            <input type="email" name="emailMod" value="<%= request.getAttribute("emailUserMod") != null ? request.getAttribute("emailUserMod") : usuario.getEmail()%>" required>
        </div>

        <div class="input-group">
            <label>Celular:</label>
            <input type="text" name="celMod" value="<%= request.getAttribute("celUserMod") != null ? request.getAttribute("celUserMod") : usuario.getCelular()%>" required>
        </div>

        <div class="input-group">
            <label>Rol del Sistema:</label>
            <% int id = request.getAttribute("rolUserMod") != null ? (int) request.getAttribute("rolUserMod") : usuario.getRol().getIdRol(); %>
            <select name="rolMod">
                <option value="2" <%= (id == 2) ? "selected" : "" %>>Común (Solo almacén)</option>
                <option value="1" <%= (id == 1) ? "selected" : "" %>>Administrador de usuarios</option>
                <option value="13" <%= (id == 13) ? "selected" : "" %>>Administrador de stock</option>
            </select>
        </div>

        <input type="hidden" name="accion" value="modUser">
        <input type="hidden" name="idUserMod" value="<%=usuario.getIdUser()%>">

        <div class="button-group">
            <a href="TablaUser.jsp" class="btn-volver">Volver</a>
            <button type="submit" class="btn-submit">Guardar Cambios</button>
        </div>

    </form>
</div>

</body>
</html>

<%--    <% Usuario usuario = (Usuario) request.getAttribute("usuarioMod"); %>--%>
<%--    <form action="SvUsuario" method="post">--%>
<%--        <p><label>Nombre Usuario: </label><input type="text" name="nomMod"--%>
<%--                                                 value="<%=request.getAttribute("nombreUserMod") != null ? request.getAttribute("nombreUserMod") : usuario.getNombreUser()%>">--%>
<%--        </p>--%>
<%--        <p><label>Email: </label><input type="text" name="emailMod"--%>
<%--                                        value="<%= request.getAttribute("emailUserMod") != null ? request.getAttribute("emailUserMod") : usuario.getEmail()%>">--%>
<%--        </p>--%>
<%--        <p><label>Celular: </label><input type="text" name="celMod"--%>
<%--                                          value="<%= request.getAttribute("celUserMod") != null ? request.getAttribute("celUserMod") : usuario.getCelular()%>">--%>
<%--        </p>--%>
<%--        <select name="rolMod">--%>
<%--            <option value="2">Común (Solo almacén)</option>--%>
<%--            <option value="1">Administrador de usuarios</option>--%>
<%--            <option value="13">Administrador de stock</option>--%>
<%--        </select>--%>
<%--        <input type="hidden" name="accion" value="modUser">--%>
<%--        <input type="hidden" name="idUserMod" value="<%=usuario.getIdUser()%>">--%>
<%--        <button type="submit">Confirmar Modificacion</button>--%>
<%--    </form>--%>

<%--    <form action="TablaUser.jsp">--%>
<%--        <button type="submit">Volver</button>--%>
<%--    </form>--%>
