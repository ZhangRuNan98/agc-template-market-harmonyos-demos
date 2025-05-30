import { CourseDetail } from '../components/course/CourseDetail'
import { AddBooking } from '../components/book/AddBooking'
import { BookingDetail } from '../components/book/BookingDetail'
import { BookingRecord } from '../components/book/BookingRecord'
import { ConfirmBooking } from '../components/book/ConfirmBooking'
import { ShowAllCourse } from '../components/course/ShowAllCourse'

@Builder
export function CourseDetailBuilder() {
  CourseDetail();
}

@Builder
export function AddBookingBuilder() {
  AddBooking();
}

@Builder
export function BookingDetailBuilder() {
  BookingDetail();
}

@Builder
export function BookingRecordBuilder() {
  BookingRecord();
}

@Builder
export function ConfirmBookingBuilder() {
  ConfirmBooking();
}

@Builder
export function ShowAllCourseBuilder() {
  ShowAllCourse();
}

