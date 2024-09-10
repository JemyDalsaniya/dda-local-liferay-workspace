package dda.user.profile.dto;

/**
 * Data Transfer Object (DTO) for order details.
 * This class is used to transfer order information within the application.
 */
public class OrderDTO {

    String orderId;
    String orderItemId;
    String date;
    String productName;
    String subscriptionType;
    String status;
    String price;
    String quantity;
    String productDescription;
    String productImageUrl;

    public OrderDTO() {
    }

    public OrderDTO(String orderId, String orderItemId, String date, String productName, String subscriptionType, String status, String price, String quantity, String productDescription, String productImageUrl) {
        this.orderId = orderId;
        this.orderItemId = orderItemId;
        this.date = date;
        this.productName = productName;
        this.subscriptionType = subscriptionType;
        this.status = status;
        this.price = price;
        this.quantity = quantity;
        this.productDescription = productDescription;
        this.productImageUrl = productImageUrl;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(String orderItemId) {
        this.orderItemId = orderItemId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        date = date;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSubscriptionType() {
        return subscriptionType;
    }

    public void setSubscriptionType(String subscriptionType) {
        this.subscriptionType = subscriptionType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public String getProductImageUrl() {
        return productImageUrl;
    }

    public void setProductImageUrl(String productImageUrl) {
        this.productImageUrl = productImageUrl;
    }
}
