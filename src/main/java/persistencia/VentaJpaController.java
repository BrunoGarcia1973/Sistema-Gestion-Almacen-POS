package persistencia;

import back.Venta;

import javax.persistence.*;
import javax.persistence.criteria.CriteriaQuery;
import java.util.List;

public class VentaJpaController {

    private EntityManagerFactory emf = null;

    public VentaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public VentaJpaController() {
        emf = Persistence.createEntityManagerFactory("almacen");
    }

    public void create(Venta venta) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(venta);
            em.getTransaction().commit();
        } finally {
            if (em != null) em.close();
        }
    }

    public void edit(Venta venta) throws Exception {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            venta = em.merge(venta);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findVenta(venta.getIdVenta()) == null) {
                throw new Exception("El registro no existe.");
            }
            throw ex;
        } finally {
            if (em != null) em.close();
        }
    }

    public void destroy(int id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Venta venta;
            try {
                venta = em.getReference(Venta.class, id);
                venta.getIdVenta();
            } catch (EntityNotFoundException enfe) {
                throw new EntityNotFoundException("El registro con id " + id + " ya no existe.");
            }
            em.remove(venta);
            em.getTransaction().commit();
        } finally {
            if (em != null) em.close();
        }
    }

    public List<Venta> findVentaEntities() {
        return findVentaEntities(true, -1, -1);
    }

    private List<Venta> findVentaEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Venta.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Venta findVenta(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Venta.class, id);
        } finally {
            em.close();
        }
    }

}
