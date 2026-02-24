package back;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Rol {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private int idRol;
    private String tipoRol;
    private String descripRol;
    @OneToMany(mappedBy = "rol")
    private List<Usuario> usuarios = new ArrayList<>();

    // Constructores
    public Rol() {
    }

    public Rol(String descripRol, int idRol, String tipoRol, List<Usuario> usuarios) {
        this.descripRol = descripRol;
        this.idRol = idRol;
        this.tipoRol = tipoRol;
        this.usuarios = usuarios;
    }

    // geter y seter

    public String getDescripRol() {
        return descripRol;
    }

    public void setDescripRol(String descripRol) {
        this.descripRol = descripRol;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public String getTipoRol() {
        return tipoRol;
    }

    public void setTipoRol(String tipoRol) {
        this.tipoRol = tipoRol;
    }

    public List<Usuario> getUsuarios() {
        return usuarios;
    }

    public void setUsuarios(List<Usuario> usuarios) {
        this.usuarios = usuarios;
    }
}
