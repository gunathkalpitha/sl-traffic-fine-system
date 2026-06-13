import axiosInstance from './axiosInstance';

/**
 * Submit a payment for a fine.
 *
 * Request body (PaymentRequestDto):
 *   { referenceNumber, categoryCode, paymentMethod, transactionId }
 *
 * Response (PaymentResponseDto):
 *   { success, message, paidAt, receiptNumber }
 *
 * @param {object} paymentRequestDto
 * @returns {Promise<object>}
 */
export async function submitPayment(paymentRequestDto) {
  const response = await axiosInstance.post('/api/payments', paymentRequestDto);
  return response.data;
}