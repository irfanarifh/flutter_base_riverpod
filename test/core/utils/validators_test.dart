import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/core/utils/validators.dart';

void main() {
  group('AppValidators', () {
    group('required', () {
      test('returns error when value is null', () {
        final result = AppValidators.required(null);
        expect(result, isNotNull);
        expect(result, equals('This field is required'));
      });

      test('returns error when value is empty string', () {
        final result = AppValidators.required('');
        expect(result, isNotNull);
        expect(result, equals('This field is required'));
      });

      test('returns error when value contains only whitespace', () {
        final result = AppValidators.required('   ');
        expect(result, isNotNull);
        expect(result, equals('This field is required'));
      });

      test('returns custom error message when provided', () {
        final result = AppValidators.required(null, 'Username required');
        expect(result, equals('Username required'));
      });

      test('returns null when value is non-empty', () {
        expect(AppValidators.required('valid input'), isNull);
      });
    });

    group('email', () {
      test('returns error when value is null', () {
        expect(AppValidators.email(null), equals('Email address is required'));
      });

      test('returns error when value is empty', () {
        expect(AppValidators.email(''), equals('Email address is required'));
      });

      test('returns error when value is whitespace only', () {
        expect(AppValidators.email('   '), equals('Email address is required'));
      });

      test('returns error on malformed email formats', () {
        const invalidEmails = [
          'plainaddress',
          '@missingusername.com',
          'username@.com',
          'username@domain',
          'username@domain.',
          'username@domain..com',
        ];

        for (final email in invalidEmails) {
          expect(
            AppValidators.email(email),
            equals('Please enter a valid email address'),
            reason: 'Failed for email: $email',
          );
        }
      });

      test('returns null on valid email formats', () {
        const validEmails = [
          'user@example.com',
          'user.name@domain.co.id',
          'user+tag@domain.org',
          'firstname.lastname@sub.company.io',
        ];

        for (final email in validEmails) {
          expect(
            AppValidators.email(email),
            isNull,
            reason: 'Failed for valid email: $email',
          );
        }
      });
    });

    group('password', () {
      test('returns error when value is null', () {
        expect(AppValidators.password(null), equals('Password is required'));
      });

      test('returns error when value is empty', () {
        expect(AppValidators.password(''), equals('Password is required'));
      });

      test('returns error when password is shorter than 8 characters', () {
        expect(
          AppValidators.password('1234567'),
          equals('Password must be at least 8 characters long'),
        );
      });

      test('returns null when password is 8 characters or longer', () {
        expect(AppValidators.password('12345678'), isNull);
        expect(AppValidators.password('securePassword123!'), isNull);
      });
    });

    group('minLength', () {
      test('returns error when string is shorter than required minimum', () {
        expect(
          AppValidators.minLength('abc', 5),
          equals('Minimum length is 5 characters'),
        );
      });

      test('returns custom error message when provided and too short', () {
        expect(
          AppValidators.minLength('ab', 4, 'Must be at least 4 letters'),
          equals('Must be at least 4 letters'),
        );
      });

      test('returns null when string meets or exceeds required minimum', () {
        expect(AppValidators.minLength('abcde', 5), isNull);
        expect(AppValidators.minLength('abcdef', 5), isNull);
      });
    });
  });
}
