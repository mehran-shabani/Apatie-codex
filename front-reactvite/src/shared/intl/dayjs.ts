import dayjs from 'dayjs';
import jalaliday from 'jalaliday';
import 'dayjs/locale/en';
import 'dayjs/locale/fa';

dayjs.extend(jalaliday);

type SupportedCalendar = 'gregory' | 'jalali';

export const localeCalendarMap: Record<string, SupportedCalendar> = {
  fa: 'jalali',
  'fa-IR': 'jalali',
  en: 'gregory',
  'en-US': 'gregory',
};

export { dayjs };
