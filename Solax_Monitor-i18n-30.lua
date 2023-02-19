-- Quickapp Solax Monitor i18n translation


class "i18n"
function i18n:translation(language)
  translation = {
    en = {
      ["SIMULATION MODE"] = "SIMULATION MODE", 
      ["Current Power"] = "Current Power",
      ["Solar Power/m²"] = "Solar Power/m²",
      ["Today Energy"] = "Today Energy",
      ["Total Energy"] = "Total Energy",
      ["Total Power to Grid"] = "Total Power to Grid",
      ["Total Energy to Grid"] = "Total Energy to Grid",
      ["Energy from Grid"] = "Energy from Grid",
      ["Total Power/m²"] = "Total Power/m²",
      ["Battery Energy"] = "Battery Energy",
      ["AC Power R"] = "AC Power R",
      ["AC Power S"] = "AC Power S",
      ["AC Power T"] = "AC Power T",
      ["Battery Power"] = "Battery Power",
      ["Power DC1"] = "Power DC1",
      ["Power DC2"] = "Power DC2",
      ["Power DC3"] = "Power DC3",
      ["Power DC4"] = "Power DC4",
      ["Inverter Type"] = "Inverter Type",
      ["Inverter Status"] = "Inverter Status",
      ["Last update"] = "Last update"},
    pt = {
      ["SIMULATION MODE"] = "MODO SIMULAÇÃO", 
      ["Current Power"] = "Potência atual",
      ["Solar Power/m²"] = "Potência solar/m²",
      ["Today Energy"] = "Energia diária",
      ["Total Energy"] = "Total de energia",
      ["Total Power to Grid"] = "Potência total para a rede",
      ["Total Energy to Grid"] = "Energia injectada para a rede",
      ["Energy from Grid"] = "Energia da rede",
      ["Total Power/m²"] = "Potência total/m²",
      ["Battery Energy"] = "Energia da bateria",
      ["AC Power R"] = "Potência AC R",
      ["AC Power S"] = "Potência AC S",
      ["AC Power T"] = "Potência AC T",
      ["Battery Power"] = "Potência bateria",
      ["Power DC1"] = "Potência DC1",
      ["Power DC2"] = "Potência DC2",
      ["Power DC3"] = "Potência DC3",
      ["Power DC4"] = "Potência DC4",
      ["Inverter Type"] = "Tipo dde inversor",
      ["Inverter Status"] = "Estado do inversor",
      ["Last update"] = "Ultimo update"},
    nl = {
      ["SIMULATION MODE"] = "SIMULATIE MODE", 
      ["Current Power"] = "Huidig vermogen",
      ["Solar Power/m²"] = "Zon energie/m²",
      ["Today Energy"] = "Energie vandaag",
      ["Total Energy"] = "Energie totaal",
      ["Total Power to Grid"] = "Totaal vermogen naar Grid",
      ["Total Energy to Grid"] = "Totaal energie naar Grid",
      ["Energy from Grid"] = "Energie van Grid",
      ["Total Power/m²"] = "Totaal vermogen/m²",
      ["Battery Energy"] = "Batterij Energie",
      ["AC Power R"] = "AC vermogen R",
      ["AC Power S"] = "AC vermogen S",
      ["AC Power T"] = "AC vermogen T",
      ["Battery Power"] = "Battery vermogen",
      ["Power DC1"] = "Vermogen DC1",
      ["Power DC2"] = "Vermogen DC2",
      ["Power DC3"] = "Vermogen DC3",
      ["Power DC4"] = "Vermogen DC4",
      ["Inverter Type"] = "Inverter Type",
      ["Inverter Status"] = "Inverter Status",
      ["Last update"] = "Laatst bijgewerkt"},
    } 
    translation = translation[language] -- Shorten the table to only the current translation
  return translation
end

-- EOF