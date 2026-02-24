<%@ page import="back.ControladoraLogica" %>
<%@ page import="back.Usuario" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Lista de Empleados - Control de Almacén</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        /* Reset básico */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #001f3f 0%, #0074D9 100%);
            height: 100vh;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .dashboard-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 30px;
            border-radius: 20px;
            width: 100%;
            max-width: 1000px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            color: white;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
        }

        .dashboard-container h2 {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
            letter-spacing: 1px;
            font-size: 24px;
            flex-shrink: 0;
        }

        /* --- NUEVO: ESTILOS DEL BUSCADOR --- */
        .search-container {
            display: flex;
            justify-content: flex-end; /* Lo tiramos a la derecha */
            margin-bottom: 15px;
            flex-shrink: 0;
        }

        .search-input {
            width: 100%;
            max-width: 300px; /* Para que no ocupe toda la pantalla */
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 14px;
            outline: none;
            transition: all 0.3s;
        }

        .search-input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .search-input:focus {
            border-color: #0074D9;
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 10px rgba(0, 116, 217, 0.3);
        }
        /* ---------------------------------- */

        .table-wrapper {
            flex-grow: 1;
            overflow-y: auto;
            border-radius: 10px;
            margin-bottom: 20px;
            scrollbar-width: thin;
            scrollbar-color: rgba(255, 255, 255, 0.3) transparent;
        }

        .table-wrapper::-webkit-scrollbar {
            width: 8px;
        }
        .table-wrapper::-webkit-scrollbar-track {
            background: transparent;
        }
        .table-wrapper::-webkit-scrollbar-thumb {
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.05);
        }

        thead th {
            position: sticky;
            top: 0;
            background: #001f3f;
            z-index: 1;
            padding: 12px 15px;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #80c4ff;
            text-align: left;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        td {
            padding: 10px 15px;
            font-size: 14px;
            color: #f1f1f1;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        tbody tr:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .btn-action {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            color: white;
        }

        .btn-modificar { background: #f39c12; margin-right: 5px; }
        .btn-modificar:hover { background: #d68910; }
        .btn-eliminar { background: #e74c3c; }
        .btn-eliminar:hover { background: #c0392b; }

        .btn-volver {
            display: inline-block;
            align-self: flex-start;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
            flex-shrink: 0;
        }
        .btn-volver:hover { background: rgba(255, 255, 255, 0.2); }

    </style>
</head>
<body>

<div class="dashboard-container">
    <h2>Gestión de Usuarios</h2>

    <%-- NUEVO: CAJA DEL BUSCADOR --%>
    <div class="search-container">
        <input type="text" id="buscadorTabla" class="search-input" placeholder="🔍 Buscar empleado...">
    </div>

    <div class="table-wrapper">

        <%-- ATAJAMOS EL MENSAJE DE ÉXITO DE LA SESIÓN --%>
        <%
            String mensajeExito = (String) session.getAttribute("mensajeExito");
            if (mensajeExito != null) {
        %>
        <div id="cartel-exito" style="background-color: rgba(46, 204, 113, 0.2); border: 1px solid #2ecc71; color: #a9dfbf; padding: 12px; border-radius: 8px; text-align: center; margin-bottom: 20px; font-weight: 500; transition: opacity 0.5s ease;">
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

        <table>
            <thead>
            <tr>
                <th>Nombre</th>
                <th>Email</th>
                <th>Celular</th>
                <th>Rol</th>
                <th>Acciones</th>
            </tr>
            </thead>

            <tbody>
            <%
                ControladoraLogica controladoraLogica = new ControladoraLogica();
                ArrayList<Usuario> listaUser = controladoraLogica.traerTodosUser();

                if (listaUser != null && !listaUser.isEmpty()) {
                    for (Usuario usuario : listaUser) {
            %>
            <tr>
                <td><%=usuario.getNombreUser()%></td>
                <td><%=usuario.getEmail()%></td>
                <td><%=usuario.getCelular()%></td>
                <td><%=usuario.getRol().getTipoRol()%></td>

                <td>
                    <form action="SvUsuario" method="get" style="display:inline;">
                        <input type="hidden" name="accion" value="modificarUser">
                        <input type="hidden" name="idMod" value="<%=usuario.getIdUser()%>">
                        <button type="submit" class="btn-action btn-modificar">Modificar</button>
                    </form>

                    <form action="SvUsuario" method="get" style="display:inline;">
                        <input type="hidden" name="accion" value="borrarUser">
                        <input type="hidden" name="idBorrar" value="<%=usuario.getIdUser()%>">
                        <button type="submit" class="btn-action btn-eliminar">Eliminar</button>
                    </form>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="5" style="text-align: center; color: #aaa; padding: 30px;">No hay usuarios registrados todavía.</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <a href="AdminUser.jsp" class="btn-volver">⬅ Volver al Menú</a>
</div>

<%-- NUEVO: MAGIA DE JAVASCRIPT PARA EL BUSCADOR --%>
<script>
    document.getElementById('buscadorTabla').addEventListener('keyup', function() {
        // Guardamos lo que el usuario va escribiendo y lo pasamos a minúsculas
        let textoBusqueda = this.value.toLowerCase();

        // Agarramos todas las filas que están adentro del cuerpo de la tabla (tbody)
        let filas = document.querySelectorAll('tbody tr');

        filas.forEach(function(fila) {
            // Un pequeño control para no filtrar la fila que dice "No hay usuarios registrados"
            if(fila.cells.length > 1) {
                // Agarramos todo el texto de esa fila (el nombre, el mail, todo junto)
                let contenidoFila = fila.textContent.toLowerCase();

                // Si lo que escribiste está dentro del contenido de la fila, se muestra. Si no, se esconde.
                if(contenidoFila.includes(textoBusqueda)) {
                    fila.style.display = '';
                } else {
                    fila.style.display = 'none';
                }
            }
        });
    });
</script>


<%--<table border="1">--%>
<%--    <thead>--%>
<%--    <tr>--%>
<%--        <th>Nombre User</th>--%>
<%--        <th>Email</th>--%>
<%--        <th>Celular</th>--%>
<%--        <th>Acciones</th>--%>
<%--    </tr>--%>
<%--    </thead>--%>

<%--    <tbody>--%>
<%--    <%--%>
<%--        ControladoraLogica controladoraLogica = new ControladoraLogica();--%>
<%--        ArrayList<Usuario> listaUser = controladoraLogica.traerTodosUser();--%>

<%--        // 3. Empezamos a dar vueltas. Por cada usuario, creamos una FILA nueva.--%>
<%--        for (Usuario usuario : listaUser) {--%>
<%--    %>--%>
<%--    <tr>--%>
<%--        <td><%=usuario.getNombreUser()%></td>--%>
<%--        <td><%=usuario.getEmail()%></td>--%>
<%--        <td><%=usuario.getCelular()%></td>--%>

<%--        <td>--%>
<%--            <form action="SvUsuario" method="get" style="display:inline;">--%>
<%--                <input type="hidden" name="accion" value="modificarUser">--%>
<%--                <input type="hidden" name="idMod" value="<%=usuario.getIdUser()%>">--%>
<%--                <button type="submit">Modificar</button>--%>
<%--            </form>--%>

<%--            <form action="SvUsuario" method="get" style="display:inline;">--%>
<%--                <input type="hidden" name="accion" value="borrarUser">--%>
<%--                <input type="hidden" name="idBorrar" value="<%=usuario.getIdUser()%>">--%>
<%--                <button type="submit">Eliminar</button>--%>
<%--            </form>--%>
<%--        </td>--%>
<%--    </tr>--%>
<%--    <%--%>
<%--        } // 6. Cerramos la llave del bucle FOR --%>
<%--    %>--%>
<%--    </tbody>--%>
<%--</table>--%>




</body>
</html>





<%--<%@ page import="back.ControladoraLogica" %>--%>
<%--<%@ page import="back.Usuario" %>--%>
<%--<%@ page import="java.util.ArrayList" %>--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="es">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <title>Lista de Empleados - Control de Almacén</title>--%>

<%--    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">--%>

<%--    <style>--%>
<%--        /* Reset básico */--%>
<%--        * {--%>
<%--            margin: 0;--%>
<%--            padding: 0;--%>
<%--            box-sizing: border-box;--%>
<%--            font-family: 'Poppins', sans-serif;--%>
<%--        }--%>

<%--        body {--%>
<%--            background: linear-gradient(135deg, #001f3f 0%, #0074D9 100%);--%>
<%--            height: 100vh; /* FIJAMOS LA ALTURA AL 100% DE LA PANTALLA */--%>
<%--            overflow: hidden; /* CORTAMOS EL SCROLL EXTERNO DEL NAVEGADOR */--%>
<%--            display: flex;--%>
<%--            align-items: center;--%>
<%--            justify-content: center;--%>
<%--            padding: 20px;--%>
<%--        }--%>

<%--        .dashboard-container {--%>
<%--            background: rgba(255, 255, 255, 0.1);--%>
<%--            backdrop-filter: blur(12px);--%>
<%--            -webkit-backdrop-filter: blur(12px);--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.2);--%>
<%--            padding: 30px; /* Reduje un poco el padding general */--%>
<%--            border-radius: 20px;--%>
<%--            width: 100%;--%>
<%--            max-width: 1000px;--%>
<%--            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);--%>
<%--            color: white;--%>
<%--            /* Le damos un alto máximo relativo a la pantalla para que no se pase */--%>
<%--            max-height: 90vh;--%>
<%--            display: flex;--%>
<%--            flex-direction: column; /* Para ordenar el título, la tabla y el botón */--%>
<%--        }--%>

<%--        .dashboard-container h2 {--%>
<%--            text-align: center;--%>
<%--            margin-bottom: 20px;--%>
<%--            font-weight: 600;--%>
<%--            letter-spacing: 1px;--%>
<%--            font-size: 24px;--%>
<%--            flex-shrink: 0; /* Evita que el título se achique */--%>
<%--        }--%>

<%--        /* --- CONTENEDOR DEL SCROLL AJUSTADO --- */--%>
<%--        .table-wrapper {--%>
<%--            flex-grow: 1; /* Le decimos que ocupe el espacio sobrante */--%>
<%--            overflow-y: auto;--%>
<%--            border-radius: 10px;--%>
<%--            margin-bottom: 20px;--%>
<%--            /* Estilo para la barrita de scroll webkit (Chrome/Edge/Safari) */--%>
<%--            scrollbar-width: thin;--%>
<%--            scrollbar-color: rgba(255, 255, 255, 0.3) transparent;--%>
<%--        }--%>

<%--        /* Diseño de la barrita de scroll */--%>
<%--        .table-wrapper::-webkit-scrollbar {--%>
<%--            width: 8px;--%>
<%--        }--%>
<%--        .table-wrapper::-webkit-scrollbar-track {--%>
<%--            background: transparent;--%>
<%--        }--%>
<%--        .table-wrapper::-webkit-scrollbar-thumb {--%>
<%--            background-color: rgba(255, 255, 255, 0.3);--%>
<%--            border-radius: 10px;--%>
<%--        }--%>

<%--        table {--%>
<%--            width: 100%;--%>
<%--            border-collapse: collapse;--%>
<%--            background: rgba(255, 255, 255, 0.05);--%>
<%--        }--%>

<%--        thead th {--%>
<%--            position: sticky;--%>
<%--            top: 0;--%>
<%--            background: #001f3f;--%>
<%--            z-index: 1;--%>
<%--            padding: 12px 15px; /* Achiqué un poco el alto de la celda */--%>
<%--            font-weight: 600;--%>
<%--            font-size: 14px;--%>
<%--            text-transform: uppercase;--%>
<%--            letter-spacing: 0.5px;--%>
<%--            color: #80c4ff;--%>
<%--            text-align: left;--%>
<%--            border-bottom: 2px solid rgba(255, 255, 255, 0.2);--%>
<%--        }--%>

<%--        td {--%>
<%--            padding: 10px 15px; /* Achiqué el alto de las celdas de datos */--%>
<%--            font-size: 14px;--%>
<%--            color: #f1f1f1;--%>
<%--            border-bottom: 1px solid rgba(255, 255, 255, 0.1);--%>
<%--        }--%>

<%--        tbody tr:hover {--%>
<%--            background: rgba(255, 255, 255, 0.1);--%>
<%--        }--%>

<%--        .btn-action {--%>
<%--            padding: 6px 10px; /* Botones un pelín más chicos */--%>
<%--            border: none;--%>
<%--            border-radius: 6px;--%>
<%--            font-size: 12px;--%>
<%--            font-weight: 600;--%>
<%--            cursor: pointer;--%>
<%--            transition: all 0.2s;--%>
<%--            color: white;--%>
<%--        }--%>

<%--        .btn-modificar { background: #f39c12; margin-right: 5px; }--%>
<%--        .btn-modificar:hover { background: #d68910; }--%>
<%--        .btn-eliminar { background: #e74c3c; }--%>
<%--        .btn-eliminar:hover { background: #c0392b; }--%>

<%--        .btn-volver {--%>
<%--            display: inline-block;--%>
<%--            align-self: flex-start; /* Alineado a la izquierda */--%>
<%--            padding: 10px 20px;--%>
<%--            background: rgba(255, 255, 255, 0.1);--%>
<%--            color: white;--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.3);--%>
<%--            border-radius: 8px;--%>
<%--            text-decoration: none;--%>
<%--            transition: all 0.3s;--%>
<%--            flex-shrink: 0;--%>
<%--        }--%>
<%--        .btn-volver:hover { background: rgba(255, 255, 255, 0.2); }--%>

<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>

<%--<div class="dashboard-container">--%>
<%--    <h2>Gestión de Usuarios</h2>--%>

<%--    <div class="table-wrapper">--%>

<%--        &lt;%&ndash; ATAJAMOS EL MENSAJE DE ÉXITO DE LA SESIÓN &ndash;%&gt;--%>
<%--        <%--%>
<%--            String mensajeExito = (String) session.getAttribute("mensajeExito");--%>
<%--            if (mensajeExito != null) {--%>
<%--        %>--%>
<%--        <div id="cartel-exito" style="background-color: rgba(46, 204, 113, 0.2); border: 1px solid #2ecc71; color: #a9dfbf; padding: 12px; border-radius: 8px; text-align: center; margin-bottom: 20px; font-weight: 500; transition: opacity 0.5s ease;">--%>
<%--            ✅ <%= mensajeExito %>--%>
<%--        </div>--%>

<%--        <script>--%>
<%--            setTimeout(function() {--%>
<%--                let cartel = document.getElementById('cartel-exito');--%>
<%--                if (cartel) {--%>
<%--                    cartel.style.opacity = '0'; // Lo hace transparente suavemente--%>
<%--                    setTimeout(function() { cartel.style.display = 'none'; }, 500); // Lo quita del espacio--%>
<%--                }--%>
<%--            }, 3000); // 3000 milisegundos = 3 segundos--%>
<%--        </script>--%>
<%--        <%--%>
<%--                // Lo borramos del servidor para que no vuelva si apretás F5--%>
<%--                session.removeAttribute("mensajeExito");--%>
<%--            }--%>
<%--        %>--%>

<%--        <table>--%>
<%--            <thead>--%>
<%--            <tr>--%>
<%--                <th>Nombre</th>--%>
<%--                <th>Email</th>--%>
<%--                <th>Celular</th>--%>
<%--                <th>Rol</th>--%>
<%--                <th>Acciones</th>--%>
<%--            </tr>--%>
<%--            </thead>--%>

<%--            <tbody>--%>
<%--            <%--%>
<%--                ControladoraLogica controladoraLogica = new ControladoraLogica();--%>
<%--                ArrayList<Usuario> listaUser = controladoraLogica.traerTodosUser();--%>

<%--                if (listaUser != null && !listaUser.isEmpty()) {--%>
<%--                    for (Usuario usuario : listaUser) {--%>
<%--            %>--%>
<%--            <tr>--%>
<%--                <td><%=usuario.getNombreUser()%></td>--%>
<%--                <td><%=usuario.getEmail()%></td>--%>
<%--                <td><%=usuario.getCelular()%></td>--%>
<%--                <td><%=usuario.getRol().getTipoRol()%></td>--%>

<%--                <td>--%>
<%--                    <form action="SvUsuario" method="get" style="display:inline;">--%>
<%--                        <input type="hidden" name="accion" value="modificarUser">--%>
<%--                        <input type="hidden" name="idMod" value="<%=usuario.getIdUser()%>">--%>
<%--                        <button type="submit" class="btn-action btn-modificar">Modificar</button>--%>
<%--                    </form>--%>

<%--                    <form action="SvUsuario" method="get" style="display:inline;">--%>
<%--                        <input type="hidden" name="accion" value="borrarUser">--%>
<%--                        <input type="hidden" name="idBorrar" value="<%=usuario.getIdUser()%>">--%>
<%--                        <button type="submit" class="btn-action btn-eliminar">Eliminar</button>--%>
<%--                    </form>--%>
<%--                </td>--%>
<%--            </tr>--%>
<%--            <%--%>
<%--                }--%>
<%--            } else {--%>
<%--            %>--%>
<%--            <tr>--%>
<%--                <td colspan="5" style="text-align: center; color: #aaa; padding: 30px;">No hay usuarios registrados todavía.</td>--%>
<%--            </tr>--%>
<%--            <%--%>
<%--                }--%>
<%--            %>--%>
<%--            </tbody>--%>
<%--        </table>--%>
<%--    </div>--%>

<%--    <a href="AdminUser.jsp" class="btn-volver">⬅ Volver al Menú</a>--%>
<%--</div>--%>

<%--    <%--%>
<%--        ControladoraLogica controladoraLogica = new ControladoraLogica();--%>
<%--        ArrayList<Usuario> listaUser = controladoraLogica.traerTodosUser();--%>
<%--        for (Usuario usuario : listaUser) {--%>

<%--    %>--%>
<%--        <p>Nombre User: <%=usuario.getNombreUser()%></p>--%>
<%--        <p>Email: <%=usuario.getEmail()%></p>--%>
<%--        <p>Celular: <%=usuario.getCelular()%></p>--%>
<%--        <form action="SvUsuario" method="get">--%>
<%--            <input type="hidden" name="accion" value="modificarUser">--%>
<%--            <input type="hidden" name="idMod" value="<%usuario.getIdUser(); %>">--%>
<%--            <button>Modificar usuario</button>--%>
<%--        </form>--%>

<%--    <form action="SvUsuario" method="get">--%>
<%--        <input type="hidden" name="accion" value="borrarUser">--%>
<%--        <input type="hidden" name="idBorrar" value="<%usuario.getIdUser(); %>">--%>
<%--        <button>Eliminar usuario</button>--%>
<%--    </form>--%>

<%--    <% }%>--%>




</body>
</html>


