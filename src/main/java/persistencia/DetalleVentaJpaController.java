package persistencia;

import back.DetalleVenta;

import javax.persistence.*;
import javax.persistence.criteria.CriteriaQuery;
import java.util.List;

public class DetalleVentaJpaController {

    private EntityManagerFactory emf = null;

    public DetalleVentaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public DetalleVentaJpaController() {
        emf = Persistence.createEntityManagerFactory("almacen");
    }

    public void create(DetalleVenta detalleVenta) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(detalleVenta);
            em.getTransaction().commit();
        } finally {
            if (em != null) em.close();
        }
    }

    public void edit(DetalleVenta detalleVenta) throws Exception {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            detalleVenta = em.merge(detalleVenta);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findDetalleVenta(detalleVenta.getIdDetalle()) == null) {
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
            DetalleVenta detalleVenta;
            try {
                detalleVenta = em.getReference(DetalleVenta.class, id);
                detalleVenta.getIdDetalle();
            } catch (EntityNotFoundException enfe) {
                throw new EntityNotFoundException("El registro con id " + id + " ya no existe.");
            }
            em.remove(detalleVenta);
            em.getTransaction().commit();
        } finally {
            if (em != null) em.close();
        }
    }

    public List<DetalleVenta> findDetalleVentaEntities() {
        return findDetalleVentaEntities(true, -1, -1);
    }

    private List<DetalleVenta> findDetalleVentaEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(DetalleVenta.class));
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

    public DetalleVenta findDetalleVenta(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(DetalleVenta.class, id);
        } finally {
            em.close();
        }
    }

}
