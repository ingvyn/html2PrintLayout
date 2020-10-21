//Скрипт автоматически проставляет буквенные указатели (готовые графические файлы от А до Я даются в виде ссылки на папку)
//по текущему описанию лек. препарата в правый край правой полосы каждого разворота главы описаний лекарст. препаратов
// Capital Index Set.jsx
//
// Modified 2018-11-30
// Igor Nikitin, Rls

//Main();
// If you want the script to be un-doable, comment out the line above, and remove the comment from the line below
app.doScript(Main, undefined, undefined, UndoModes.ENTIRE_SCRIPT,"Run Script");

function Main() {
	// Check to see whether any InDesign documents are open.
	// If no documents are open, display an error message.
	if (app.documents.length > 0) {
        var myDoc = app.documents[0];
        var currentIndexLetter="";
        var foundIndexLetter;
        var indexVerticalPosition = 16; // прирост координат Y происходит по факту первой смены заглавной буквы описания на развороте. Для первого разворота реальная координата также получается после инкремента по факту нахождения заглавной кириллической буквы в описаниях на первом развороте. Поэтому начальное значение равно фактическому на первом развороте минус шаг прироста
        const INDEX_HorizontalPosition = 190.5;        
        const INDEX_LETTER_WIDTH = 20;
        const INDEX_LETTER_HEIGHT = 7;
        const PATH_TO_FILES_WITH_INDEX_LETTERS = "C:\\enc2021\\Plashka_color_EPS\\";
        const EXTENSION_OF_FILES_WITH_INDEX_LETTERS = ".eps"; // расширение графических файлов в папке
        var foundHeadingCapilals = [];
        var indexGeometricBounds = [];
        
        with (myDoc.viewPreferences) {
            horizontalMeasurementUnits = MeasurementUnits.MILLIMETERS;
            verticalMeasurementUnits = MeasurementUnits.MILLIMETERS;
            rulerOrigin = RulerOrigin.SPINE_ORIGIN; // выставляем "ноль" координатной сетки в корешок
        }
        
        app.findGrepPreferences = NothingEnum.NOTHING;
// чтобы сразу исключить проверку первых букв в заголовке описания на кирилличность, организуем GREP-поиск с указанным ниже шаблоном по указанному стилю абзаца. Абзац COLONT_Opis специально организован в макете, чтобы избежать орагнизации колонтитулов по двум различным абзацам, так же и удобнее организовать поиск по одному абзацу, который дублирует содержимое капк абзацев OPIS_Largetone, так и Opis_DV_Opis
        app.findGrepPreferences.appliedParagraphStyle = myDoc.paragraphStyles.itemByName("COLONT_Opis");
        app.findGrepPreferences.findWhat = "[А-Я].+";  //шаблон Grep-поиска
        var firstSpreadCompletenessIndicator = (myDoc.documentPreferences.startPageNumber % 2 == 0) ? 1 : 0; // цикл начинается с 1, т.е. со второй страницы первого разворота - это бывает в случае, когда разворот полный, т.е. первая страница четная; в противном случае цикл начинатеся с нуля
        for (var i=firstSpreadCompletenessIndicator; i < myDoc.pages.length; i+=2) {
            app.activeWindow.activePage = myDoc.pages[i]; //в цикле перебираются правые страницы разворотов, в силу особенностей нумерации массивов в массиве они обозначаются четными номерами 
            foundHeadingCapilals = (i == 0) ? myDoc.pages[i].textFrames[0].findGrep() : myDoc.pages[i-1].textFrames[0].findGrep().concat(myDoc.pages[i].textFrames[0].findGrep()); //для нулевого разворота массив  формируется из найденных абзацев первой полосы, для остальных разворотов из найденных абзацев обоих полос разворота
            for (var ns = foundHeadingCapilals.length - 1; ns >= 0; ns-- ) {
                foundIndexLetter = foundHeadingCapilals[ns].contents.charAt(0).toLowerCase(); //первый символ проверяемого абзаца
                if (foundIndexLetter != currentIndexLetter) { //сравнивается с текущим индексом
                    currentIndexLetter = foundIndexLetter;   // текущий индекс получает новое значение
                    indexVerticalPosition +=INDEX_LETTER_HEIGHT;  // координата по Y графического указателя получает приращение, равное высоте граф. указателя(плашки) INDEX_LETTER_HEIGHT
                    break;
                }
            }
            with (myDoc.pages[i].rectangles.add()) { //создается новый фрейм
                indexGeometricBounds[0] = indexVerticalPosition + 'mm';
                indexGeometricBounds[1] = INDEX_HorizontalPosition + 'mm';
                indexGeometricBounds[2] = (indexVerticalPosition + INDEX_LETTER_HEIGHT) + 'mm';
                indexGeometricBounds[3] = (INDEX_HorizontalPosition + INDEX_LETTER_WIDTH) + 'mm';
                geometricBounds = indexGeometricBounds; //и позиционируется в заданные координаты
//                move([(540,65.197),(596.693,85.039)]);
                place(PATH_TO_FILES_WITH_INDEX_LETTERS + currentIndexLetter + EXTENSION_OF_FILES_WITH_INDEX_LETTERS); // во фрейме размещается граф. файл с изображением текущего указателя
                fit(FitOptions.FILL_PROPORTIONALLY); // с опцией Уместить пропорционально
            }
        }  
        with (myDoc.viewPreferences) {
            horizontalMeasurementUnits = MeasurementUnits.MILLIMETERS;
            verticalMeasurementUnits = MeasurementUnits.MILLIMETERS;
            rulerOrigin = RulerOrigin.SPREAD_ORIGIN; // выставляем "ноль" координатной сетки в левый верхний угол разворота
        }        
		alert("Finished!");
	}
	else {
		// No documents are open, so display an error message.
		alert("No InDesign documents are open. Please open a document and try again.");
	}
}