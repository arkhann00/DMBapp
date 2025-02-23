//
//  String.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.07.2024.
//

import Foundation
import SwiftUI

extension String {
    
    func isEnglishLettersOrDigits() -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        return self.allSatisfy { allowedCharacters.contains($0.unicodeScalars.first!) }
    }
    
    func localize(language: String) -> String {
        
        if language == "default" { return self }
        let translation = getLocalization(language: language)
        guard let translatedString = translation[self] else { return self }
        return translatedString
        
    }
    
    private func getLocalization(language: String) -> [String : String] {
        
        switch language {
        case "russian":
            let russian = [
                "WHO ARE YOU?" : "КТО ВЫ?",
                "Soldier" : "Солдат",
                "Officer" : "Офицер",
                "Cadet" : "Курсант",
                "Soldier's Relative" : "Родственник солдата",
                "Next" : "Далее",
                "Skip" : "Пропустить",
                "ADDING A SOLDIER" : "ДОБАВЛЕНИЕ СОЛДАТА",
                "Date of conscription" : "Дата призыва",
                "Date of demobilization" : "Дата демобилизации",
                "SAVE" : "СОХРАНИТЬ",
                "REGISTRATION" : "РЕГИСТРАЦИЯ",
                "Mail" : "Почта",
                "Password" : "Пароль",
                "Repeat password" : "Повторите пароль",
                "Have an account?" : "Есть аккаунт?",
                "Login" : "Войти",
                "PROFILE" : "ПРОФИЛЬ",
                "Name" : "Имя",
                "Nickname" : "Ник-нейм",
                "Add a photo" : "Добавить фотографию",
                "PASSED" : "ПРОШЛО",
                "LEFT" : "ОСТАЛОСЬ",
                "REGISTER" : "ЗАРЕГИСТРИРОВАТЬСЯ",
                "ALREADY PASSED" : "УЖЕ ПРОШЛО",
                "STILL LEFT" : "ЕЩЁ ОСТАЛОСЬ",
                "days until demobilization" : "дней до дембеля",
                "Settings" : "Настройки",
                "Background Darkening" : "Затемнение фона",
                "Background Animation" : "Анимация фона",
                "Language" : "Язык",
                "GENERAL CHAT" : "ОБЩИЙ ЧАТ",
                "Find User" : "Найти пользователя",
                "JANUARY" : "ЯНВАРЬ",
                "FEBRUARY" : "ФЕВРАЛЬ",
                "MARCH" : "МАРТ",
                "APRIL" : "АПРЕЛЬ",
                "MAY" : "МАЙ",
                "JUNE" : "ИЮНЬ",
                "JULY" : "ИЮЛЬ",
                "AUGUST" : "АВГУСТ",
                "SEPTEMBER" : "СЕНТЯБРЬ",
                "OCTOBER" : "ОКТЯБРЬ",
                "NOVEMBER" : "НОЯБРЬ",
                "DECEMBER" : "ДЕКАБРЬ",
                "M" : "ПН",
                "T" : "ВТ",
                "W" : "СР",
                "Th" : "ЧТ",
                "Delete" : "Удалить",
                "F" : "ПТ",
                "Sa" : "СБ",
                "Su" : "ВС",
                "days before" : "дней до",
                "ADDING AN EVENT" : "ДОБАВЛЕНИЕ СОБЫТИЯ",
                "Event name" : "Название события",
                "Event date:" : "Дата события:",
                "ADD PHOTO TO BACKGROUND" : "ДОБАВИТЬ ФОТО НА ФОН",
                "SOON" : "СКОРО",
                "YES" : "ДА",
                "NO" : "НЕТ",
                "days" : "дней",
                "hours" : "часов",
                "minutes" : "минут",
                "seconds" : "секунд",
                "Application icon" : "Иконка приложения",
                "Login via" : "Войти через",
                "FRIENDS" : "ДРУЗЬЯ",
                "Friend requests" : "Заявки в друзья",
                "No requests" : "Заявок нет",
                "The user" : "Пользователь",
                "wants" : "хочет",
                "to  add  you  as  a  friend" : "добавить  Вас  в  друзья",
                "Invalid mail format" : "Неверный формат почты",
                "Passwords don't match" : "Пароли не совпадают",
                "Show password" : "Показать пароль",
                "Don't have an account?" : "Нет аккаунта?",
                "Register" : "Зарегестрироваться",
                "SOMETHING WENT WRONG" : "ЧТО-ТО ПОШЛО НЕ ТАК",
                "EDITING YOUR PROFILE" : "РЕДАКТИРОВАНИЕ ПРОФИЛЯ",
                "Log out of your account" : "Удалить аккаунт",
                "Delete account" : "Удалить аккаунт",
                "Are you sure you want to delete your account?" : "Вы точно хотите удалить аккаунт?",
                
                "Cancel" : "Отмена",
                "If you delete your account, there will be no way to restore your data" : "При удалении аккаунта, не будет возможности восстановить данные",
                "Unfriend" : "Удалить из друзей",
                "Add as friend" : "Добавить в друзья",
                "Write a message" : "Написать сообщение",
                "No Internet" : "Нет сети",
                "Password length from 6 to 128 characters" : "Длина пароля от 6 до 128 символов",
            ]
            return russian
        case "english":
            let english = [
            "КТО ВЫ?" : "WHO ARE YOU?",
            "Солдат" : "Soldier",
            "Офицер" : "Officer",
            "Курсант" : "Cadet",
            "Родственник солдата" : "Soldier's Relative",
            "Далее" : "Next",
            "Пропустить" : "Skip",
            "ДОБАВЛЕНИЕ СОЛДАТА" : "ADDING A SOLDIER",
            "Дата призыва" : "Date of conscription",
            "Дата дембеля" : "Date of demobilization",
            "СОХРАНИТЬ" : "SAVE",
            "РЕГИСТРАЦИЯ" : "REGISTRATION",
            "Почта" : "Mail",
            "Пароль" : "Password",
            "Повторите пароль" : "Repeat password",
            "Есть аккаунт?" : "Have an account?",
            "Войти" : "Login",
            "ПРОФИЛЬ" : "PROFILE",
            "Имя" : "Name",
            "Ник-нейм" : "Nickname",
            "Добавить фотографию" : "Add a photo",
            "ПРОШЛО" : "PASSED",
            "ОСТАЛОСЬ" : "LEFT",
            "ЗАРЕГЕСТРИРОВАТЬСЯ" : "REGISTER",
            "УЖЕ ПРОШЛО" : "ALREADY PASSED",
            "ЕЩЁ ОСТАЛОСЬ" : "STILL LEFT",
            "дней до дембеля" : "days until demobilization",
            "Настройки" : "Settings",
            "Затемнение фона" : "Background Darkening",
            "Анимация фона" : "Background Animation",
            "Язык" : "Language",
            "ОБЩИЙ ЧАТ" : "GENERAL CHAT",
            "Найти пользователя" : "Find User",
            "ЯНВАРЬ" : "JANUARY",
            "ФЕВРАЛЬ" : "FEBRUARY",
            "МАРТ" : "MARCH",
            "АПРЕЛЬ" : "APRIL",
            "МАЙ" : "MAY",
            "ИЮНЬ" : "JUNE",
            "ИЮЛЬ" : "JULY",
            "АВГУСТ" : "AUGUST",
            "СЕНТЯБРЬ" : "SEPTEMBER",
            "ОКТЯБРЬ" : "OCTOBER",
            "НОЯБРЬ" : "NOVEMBER",
            "ДЕКАБРЬ" : "DECEMBER",
            "ПН" : "M",
            "ВТ" : "T",
            "СР" : "W",
            "ЧТ" : "Th",
            "ПТ" : "F",
            "СБ" : "Sa",
            "ВС" : "Su",
            "Удалить" : "Delete",
            "дней до" : "days before",
            "ДОБАВЛЕНИЕ СОБЫТИЯ" : "ADDING AN EVENT",
            "Название события" : "Event name",
            "Дата события:" : "Event date:",
            "ДОБАВИТЬ ФОТО НА ФОН" : "ADD PHOTO TO BACKGROUND",
            "СКОРО" : "SOON",
            "ДА" : "YES",
            "НЕТ" : "NO",
            "дней" : "days",
            "часов" : "hours",
            "минут" : "minutes",
            "секунд" : "seconds",
            "Иконка приложения" : "Application icon",
            "Войти через" : "Login via",
            "ДРУЗЬЯ" : "FRIENDS",
            "Заявки в друзья" : "Friend requests",
            "Заявок нет" : "No requests",
            "Пользователь" : "The user",
            "хочет" : "wants",
            "добавить  Вас  в  друзья" : "add  you  as  a  friend",
            "Неверный формат почты" : "Invalid mail format",
            "Пароли не совпадают" : "Passwords don't match",
            "Показать пароль" : "Show password",
            "Скрыть пароль" : "Hide password",
            "Нет аккаунта?" : "Don't have an account?",
            "Зарегестрироваться" : "Register",
            "ЧТО-ТО ПОШЛО НЕ ТАК" : "SOMETHING WENT WRONG",
            "РЕДАКТИРОВАНИЕ ПРОФИЛЯ" : "EDITING YOUR PROFILE",
            "Выйти из аккаунта" : "Log out of your account",
            "Удалить аккаунт" : "Delete account",
            "Вы точно хотите удалить аккаунт?" : "Are you sure you want to delete your account?",
            
            "Отмена" : "Cancel",
            "При удалении аккаунта, не будет возможности восстановить данные" : "If you delete your account, there will be no way to restore your data",
            "Удалить из друзей" : "Unfriend",
            "Добавить в друзья" : "Add as friend",
            "Написать сообщение" : "Write a message",
            "Нет сети" : "No Internet",
            "Длина пароля от 6 до 128 символов" : "Password length from 6 to 128 characters",
            ]
            return english
        default:
            return [:]
        }
        
    }
    
    func isValidMail() -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    func decodeBase64StringToImage() -> UIImage? {
        // Удаляем пробелы и переносы строк из строки Base64 (если есть)
        let cleanedBase64String = self.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")

        // Преобразуем строку Base64 в Data
        if let imageData = Data(base64Encoded: cleanedBase64String, options: .ignoreUnknownCharacters) {
            // Преобразуем Data в UIImage
            return UIImage(data: imageData)
        }
        
        // Возвращаем nil, если декодирование не удалось
        return nil
    }
    
}

