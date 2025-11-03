package com.example.demo.dto.event;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class InvoiceGeneratedEvent {
    private Long invoiceId;
    private Long orderId;
    private Long userId;
    private BigDecimal amount;
    private LocalDateTime generationDate;

    public InvoiceGeneratedEvent() {
    }

    public InvoiceGeneratedEvent(Long invoiceId, Long orderId, Long userId, BigDecimal amount, LocalDateTime generationDate) {
        this.invoiceId = invoiceId;
        this.orderId = orderId;
        this.userId = userId;
        this.amount = amount;
        this.generationDate = generationDate;
    }

    public Long getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(Long invoiceId) {
        this.invoiceId = invoiceId;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDateTime getGenerationDate() {
        return generationDate;
    }

    public void setGenerationDate(LocalDateTime generationDate) {
        this.generationDate = generationDate;
    }

    @Override
    public String toString() {
        return "InvoiceGeneratedEvent{" +
               "invoiceId=" + invoiceId +
               ", orderId=" + orderId +
               ", userId=" + userId +
               ", amount=" + amount +
               ", generationDate=" + generationDate +
               '}';
    }
}
