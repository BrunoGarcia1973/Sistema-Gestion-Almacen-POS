package Servlet;

import back.ControladoraLogica;
import back.Rol;
import back.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "SvUsuario", urlPatterns = {"/SvUsuario"})
public class SvUsuario extends HttpServlet {

    ControladoraLogica controladoraLogica = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        switch (accion) {

            case "entrar":
                ArrayList<Usuario> listaUser = controladoraLogica.traerTodosUser();
                String nombreUser = req.getParameter("nomUser");
                String contra = req.getParameter("contraUser");
                for (Usuario usuario : listaUser) {
                    if (usuario.getNombreUser().equals(nombreUser)) {
                        if (BCrypt.checkpw(contra, usuario.getContraseña())) {
                            if (usuario.getRol().getTipoRol().equals("adminUser")) {
                                resp.sendRedirect("AdminUser.jsp");
                                return;
                            } else if (usuario.getRol().getTipoRol().equals("comun")) {
                                resp.sendRedirect("AdminAlmacen.jsp");
                                return;
                            } else if (usuario.getRol().getTipoRol().equals("adminAlmacen")) {
                                resp.sendRedirect("AdminStock.jsp");
                                return;

                            }
                        }
                    }


                }
                // Cuando detectás que el usuario o la clave están mal:
                req.setAttribute("errorLogin", "Usuario o contraseña incorrectos.");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
                break;

            case "cargar":
                String nombreNuevo = req.getParameter("nomUserNuevo");
                String contraseñaNuevo = req.getParameter("contraUserNuevo");
                String celNuevo = req.getParameter("celUserNuevo");
                String emialNuevo = req.getParameter("emailUserNuevo");
                int rolNuevoId = Integer.parseInt(req.getParameter("rolUser"));
                ArrayList<Usuario> listaUserVerificar = controladoraLogica.traerTodosUser();
                for (Usuario usuario : listaUserVerificar) {
                    if (usuario.getNombreUser().equals(nombreNuevo)) {
                        req.setAttribute("mensajeError", "Nombre Usuario repetido");
                        req.setAttribute("nomGuardado", nombreNuevo);
                        req.setAttribute("emailGuardado", emialNuevo);
                        req.setAttribute("celGuardado", celNuevo);
                        req.getRequestDispatcher("AdminUserCargar.jsp").forward(req, resp);
                        return;
                    }
                    if (usuario.getEmail().equals(emialNuevo)) {
                        req.setAttribute("mensajeError", "Email repetido");
                        req.setAttribute("nomGuardado", nombreNuevo);
                        req.setAttribute("emailGuardado", emialNuevo);
                        req.setAttribute("celGuardado", celNuevo);
                        req.getRequestDispatcher("AdminUserCargar.jsp").forward(req, resp);
                        return;

                    }
                    if (usuario.getCelular().equals(celNuevo)) {
                        req.setAttribute("mensajeError", "Celular repetido");
                        req.setAttribute("nomGuardado", nombreNuevo);
                        req.setAttribute("emailGuardado", emialNuevo);
                        req.setAttribute("celGuardado", celNuevo);
                        req.getRequestDispatcher("AdminUserCargar.jsp").forward(req, resp);
                        return;
                    }
                }
                String contraseñaNuevoCifrada = BCrypt.hashpw(contraseñaNuevo, BCrypt.gensalt());
                Usuario usuarioNuevo = new Usuario();
                usuarioNuevo.setNombreUser(nombreNuevo);
                usuarioNuevo.setCelular(celNuevo);
                usuarioNuevo.setEmail(emialNuevo);
                usuarioNuevo.setContraseña(contraseñaNuevoCifrada);
                Rol rolNuevo = controladoraLogica.buscarRol(rolNuevoId);
                usuarioNuevo.setRol(rolNuevo);
                controladoraLogica.crearUser(usuarioNuevo);
                req.getSession().setAttribute("mensajeExito", "Usuario Registrado Correctamente");
                resp.sendRedirect("AdminUserCargar.jsp");
                break;

            case "modUser":
                String nombreUserMod = req.getParameter("nomMod");
                String emailUserMod = req.getParameter("emailMod");
                String celUserMod = req.getParameter("celMod");
                int idRolUserMod = Integer.parseInt(req.getParameter("rolMod"));
                int idUserMod = Integer.parseInt(req.getParameter("idUserMod"));
                ArrayList<Usuario> listaUserVerificarMod = controladoraLogica.traerTodosUser();
                for (Usuario usuario : listaUserVerificarMod) {
                    if (usuario.getIdUser() != idUserMod) {

                        if (usuario.getNombreUser().equals(nombreUserMod)) {

                            req.setAttribute("mensajeError", "El nombre de usuario ya existe");

                            req.setAttribute("nombreUserMod", nombreUserMod);
                            req.setAttribute("emailUserMod", emailUserMod);
                            req.setAttribute("celUserMod", celUserMod);
                            req.setAttribute("rolUserMod", idRolUserMod);

                            Usuario usuarioOriginal = controladoraLogica.buscarUser(idUserMod);
                            req.setAttribute("usuarioMod", usuarioOriginal);

                            req.getRequestDispatcher("AdminUserMod.jsp").forward(req, resp);
                            System.out.println("nombre user");
                            return;
                        }
                        if (usuario.getEmail().equals(emailUserMod)) {

                            req.setAttribute("mensajeError", "El Email ya existe");
                            req.setAttribute("nombreUserMod", nombreUserMod);
                            req.setAttribute("emailUserMod", emailUserMod);
                            req.setAttribute("celUserMod", celUserMod);
                            req.setAttribute("rolUserMod", idRolUserMod);

                            Usuario usuarioOriginal = controladoraLogica.buscarUser(idUserMod);
                            req.setAttribute("usuarioMod", usuarioOriginal);

                            req.getRequestDispatcher("AdminUserMod.jsp").forward(req, resp);
                            System.out.println("email iser");
                            return;
                        }
                        if (usuario.getCelular().equals(celUserMod)) {

                            req.setAttribute("mensajeError", "El celular ya existe");
                            req.setAttribute("nombreUserMod", nombreUserMod);
                            req.setAttribute("emailUserMod", emailUserMod);
                            req.setAttribute("celUserMod", celUserMod);
                            req.setAttribute("rolUserMod", idRolUserMod);

                            Usuario usuarioOriginal = controladoraLogica.buscarUser(idUserMod);
                            req.setAttribute("usuarioMod", usuarioOriginal);

                            req.getRequestDispatcher("AdminUserMod.jsp").forward(req, resp);
                            System.out.println("celular user");
                            return;
                        }

                    }

                }

                Rol rolUserMod = controladoraLogica.buscarRol(idRolUserMod);
                Usuario usuarioMod = controladoraLogica.buscarUser(idUserMod);
                usuarioMod.setNombreUser(nombreUserMod);
                usuarioMod.setEmail(emailUserMod);
                usuarioMod.setCelular(celUserMod);
                usuarioMod.setRol(rolUserMod);
                controladoraLogica.modificarUser(usuarioMod);
                req.getSession().setAttribute("mensajeExito", "Usuario Modificado Correctamente");
                resp.sendRedirect("TablaUser.jsp");
                break;


        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        switch (accion) {

            case "borrarUser":
                int idBorrar = Integer.parseInt(req.getParameter("idBorrar"));
                controladoraLogica.eliminarUser(idBorrar);
                resp.sendRedirect("TablaUser.jsp");
                break;

            case "modificarUser":
                int idMod = Integer.parseInt(req.getParameter("idMod"));
                Usuario usuarioMod = controladoraLogica.buscarUser(idMod);
                req.setAttribute("usuarioMod", usuarioMod);
                req.getRequestDispatcher("AdminUserMod.jsp").forward(req, resp);
                break;

        }
    }
}
