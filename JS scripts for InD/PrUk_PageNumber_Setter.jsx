//Скрипт для изменения стиля параграфа(ов) с определенным стилем и содержанием, удовлетворяющем GREP-запросу. Можно приспособить под любые задачи подобного типа
// Этот скрипт, в частности, изменяет стиль параграфов с номерами страниц в Предметном указателе на стиль с выключкой по правому краю
// PrUk_PageNumber_Setter.jsx
//
// Modified 2019-02-19
// Igor Nikitin, Rls

//Main();
// If you want the script to be un-doable, comment out the line above, and remove the comment from the line below
app.doScript(Main, undefined, undefined, UndoModes.ENTIRE_SCRIPT,"Run Script");

function Main() {
	// Check to see whether any InDesign documents are open.
	// If no documents are open, display an error message.
	if (app.documents.length > 0) {
        var paragraphStyleChangeSettings = { // объект, задающий все настройки изменений
            paragraphs: [  // стили параграфов, по которым осуществляется поиск
                'Puk_Preparat',
                'PUK_DVName'
            ],
            paragraphStyleChangeTo: [  // стили, которые должны получить параграфы с искомым текстом и искомым стилем
                'Puk_Preparat_PageNumberOnly',
                'PUK_DVName_PageNumberOnly'
            ],
            whatFind: "^[^{0-9A-ZА-Я\\-\\+\\[\\]()}]" // Хотел использовать GREP-запрос для поиска (цифры (после, возможно, запятая, пробел, опять цифры) возможен повтор ) ^\\d+(,\\s*.*)? . Но здесь нужен поиск маркера перкрестной ссылки - не нашел такой возможности в grep поиске Indesign, поэтому буду искать от обратного - абзацы не начинающие как привычно для данного стиля
        };
        app.findGrepPreferences = NothingEnum.NOTHING;
        app.findChangeGrepOptions.includeMasterPages = false;
        for (var p=0; p < paragraphStyleChangeSettings.paragraphs.length; p++) {
            app.findGrepPreferences.findWhat = paragraphStyleChangeSettings.whatFind; // задается GREP-запрос из объекта с настройками изменений
            app.findGrepPreferences.appliedParagraphStyle = paragraphStyleChangeSettings.paragraphs[p];  //задается поиск по искомому стилю абзаца
            var foundTexts = app.documents[0].findGrep(); // массив из найденных объектов Texts (оъектная модель InDesign)
            for (var i=0; i<foundTexts.length; i++) {
                foundTexts[i].paragraphs[0].appliedParagraphStyle = paragraphStyleChangeSettings.paragraphStyleChangeTo[p]; // меняется стиль абзаца, с текстом, удовлетворяющем условиям поиска - Grep-запросу и стилю абзаца с текстом
            }

        }
		alert("Finished!");
	}
	else {
		// No documents are open, so display an error message.
		alert("No InDesign documents are open. Please open a document and try again.");
	}
}