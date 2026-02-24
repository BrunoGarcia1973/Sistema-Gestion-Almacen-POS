package back;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Producto {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private int idProducto;
    private String marca;
    private String tipoProd;
    private double precio;
    private int stock;
    private boolean activo;
    @OneToMany(mappedBy = "producto")
    private List<DetalleVenta> lista = new ArrayList<>();

    // Constructores
    public Producto() {
    }

    public Producto(boolean activo, int idProducto, String marca, double precio, int stock, String tipoProd) {
        this.activo = activo;
        this.idProducto = idProducto;
        this.marca = marca;
        this.precio = precio;
        this.stock = stock;
        this.tipoProd = tipoProd;
    }

    // geter y seter
    public int getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getTipoProd() {
        return tipoProd;
    }

    public void setTipoProd(String tipoProd) {
        this.tipoProd = tipoProd;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
}
