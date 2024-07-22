//
//  String.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 11.07.2024.
//

import Foundation

extension String {
    
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
                "Repeat password" : "Повтор пароля",
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
                "Login via" : "Войти через"
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
            "РЕГЕСТРАЦИЯ" : "REGISTRATION",
            "Почта" : "Mail",
            "Пароль" : "Password",
            "Повтор пароля" : "Repeat password",
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
            "Войти через" : "Login via"
            ]
            return english
        default:
            return [:]
        }
        
    }
    
}

