# Как установить проект
## Ручная установка
* Скачайте проект в виде .zip-архива или клоноруйте репозиторий
* Откройте директорию `$UserBaseDirectory`
* Откройте на редактирование файл `FileNameJoin[{$UserBaseDirectory, "Kernel", "Init.m"}]`
* Вставьте в открытый файл инициализации следующее: `Get[<download path>\Source\Kernel\Init.m]`.
* Перезапустите ядро Математики.
* Выполните следующий код: ```<<WeightSpectrumLinearSubspace` ``` 

## Автоматическая установка
* Скачайте проект в виде .zip-архива или клонируйте репозиторий
* Откройте терминал в директории проекта (где находятся файлы PacletInfo.m и Installer.m)
* Выполните в терминале следующую команду: ```MathematicaScript -script Installer.m -install```
* Запустите Математику и выполните: ```<<WeightSpectrumLinearSubspace` ```
