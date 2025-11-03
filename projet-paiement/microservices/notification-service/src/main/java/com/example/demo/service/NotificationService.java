package com.example.demo.service;

import com.example.demo.dto.event.InvoiceGeneratedEvent;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    private static final Logger log = LoggerFactory.getLogger(NotificationService.class);
    private static final String INVOICE_GENERATED_TOPIC = "invoice-generated";

    private final ObjectMapper objectMapper;

    public NotificationService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @KafkaListener(topics = INVOICE_GENERATED_TOPIC, groupId = "notification-service-group")
    public void handleInvoiceGeneratedEvent(String message) {
        log.info("Received InvoiceGeneratedEvent message: {}", message);

        InvoiceGeneratedEvent invoiceGeneratedEvent;
        try {
            invoiceGeneratedEvent = objectMapper.readValue(message, InvoiceGeneratedEvent.class);
        } catch (JsonProcessingException e) {
            log.error("Failed to parse InvoiceGeneratedEvent JSON: {}", message, e);
            return;
        }

        log.info("--- SIMULATING NOTIFICATION SEND ---");
        log.info("Notification sent for Invoice ID: {} (Order ID: {}) to User ID: {}. Amount: {}",
            invoiceGeneratedEvent.getInvoiceId(),
            invoiceGeneratedEvent.getOrderId(),
            invoiceGeneratedEvent.getUserId(),
            invoiceGeneratedEvent.getAmount()
        );
        log.info("------------------------------------");
    }
}
