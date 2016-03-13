//
//  Translation.swift
//  LineTip
//
//  Created by Artur Schäfer on 13.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation

extension String {
    
    /// translates a string to the language loaded from nsdefaults
    ///
    /// :returns: the translation of the given string
    func translate() -> String {
        let language = Utils.getSettingsData(ConfigKey.TRANSLATION) as! String
        let translation = myTranslation(self, language: language)
        
        return translation
    }
    
    /// removes white spaces at the beginning and the end of the string
    ///
    /// :returns: a trimed string
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    /// translates a string. this method will change. translation files will be used instead.
    ///
    /// :returns: the translation by the language
    func myTranslation(key: String, language: String) -> String {
        var translation = key
        if(language == "DE") {
            if key == "trials" {
                translation = "Versuche"
            }
            else if key == "trial" {
                translation = "Versuch"
            }
            else if key == "user management" {
                translation = "Benutzerverwaltung"
            }
            else if key == "result view" {
                translation = "Ergebnisansicht"
            }
            else if key == "medical ID" {
                translation = "MED ID"
            }
            else if key == "NEW TRIAL" {
                translation = " Neuer Versuch"
            }
            else if key == "duration" {
                translation = "Versuchdauer"
            }
            else if key == "timestamp" {
                translation = "Versuchszeitpunkt"
            }
            else if key == "hits" {
                translation = "Treffer"
            }
            else if key == "misses" {
                translation = "Fehlversuche"
            }
            else if key == "measurement results" {
                translation = "Versuchsergebnisse"
            }
            else if key == "New user" {
                translation = "Neuer Benutzer"
            }
            else if key == "Create user" {
                translation = "Erstelle einen Benutzer"
            }
            else if key == "Save" {
                translation = "Speichern"
            }
            else if key == "Cancel" {
                translation = "Abbrechen"
            }
            else if key == "in following colors" {
                translation = "in folgenden Farben"
            }
            else if key == "Delete" {
                translation = "Löschen"
            }
            else if key == "Not enough trials yet" {
                translation = "Bisher zu wenige Versuche durchgeführt"
            }
            else if key == "Settings" {
                translation = "Einstellungen"
            }
            else if key == "Preview" {
                translation = "Vorschau"
            }
            else if key == "Line Width" {
                translation = "Linienstärke"
            }
            else if key == "Spot Width" {
                translation = "Mittelpunkt-Breite"
            }
            else if key == "Spot Height" {
                translation = "Mittelpunkt-Höhe"
            }
            else if key == "Display lines random" {
                translation = "Zufällige Liniendarstellung"
            }
            else if key == "Hit Sound" {
                translation = "Treffer-Ton"
            }
            else if key == "Miss Sound" {
                translation = "Verfehlt-Ton"
            }
            else if key == "Line Timer" {
                translation = "Linien-Timer"
            }
            else if key == "Line Timer Off" {
                translation = "Linien-Timer Aus"
            }
            else if key == "Draw every 5 s" {
                translation = "Alle 5 s neue Linie"
            }
            else if key == "Results for user" {
                translation = "Ergebniss für den Benutzer"
            }
            else if key == "Best regards" {
                translation = "Beste Grüße"
            }
            else if key == "Select User" {
                translation = "Wähle einen Benutzer"
            }
            else if key == "Quick Start" {
                translation = "Schnellstart"
            }
            else if key == "Assign Trial" {
                translation = "Versuchszuordnung"
            }
            else if key == "Please assign trial(s) to a user." {
                translation = "Bitte ordnen Sie den Versuch einem Benutzer zu."
            }
            else if key == "There is no user to assign" {
                translation = "Kein Benutzer vorhanden"
            }
            else if key == "Please create a new user to assign the trial(s)." {
                translation = "Bitte erstellen sie einen neuen Benutzer."
            }
            else if key == "Back" {
                translation = "Zurück"
            }
            else if key == "no trial yet" {
                translation = "bisher keine Versuche"
            }
            else if key == "Delete selected trial" {
                translation = "Ausgewählten Versuch löschen"
            }
            /*
            
            */
        }
        
        if(translation == "EN" ) {
            return key
        }
        return translation
    }
}
