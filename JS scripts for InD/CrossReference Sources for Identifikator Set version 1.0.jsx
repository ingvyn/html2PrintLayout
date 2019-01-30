//DESCRIPTION:
//Скрипт осуществляет поиск в xml-структуре активного документа всех элементов crossRef, устанавливает для каждого из них значение атрибута href.
// По найденному значению находится элемент массива объектов текстовых привязок со свойством name, идентичным найденному href. На место текста в элементе crossRef (предполагается, что это наполнитель 0000) устанавливается source перекрестной ссылки
//В массив гиперссылок документа добавляется элемент-гиперссылка-связка, устанавливающая связь между source и найденной текстовой привязкой (text destination)
//для того, чтобы скрипт выполнил свою задачу, предварительно должен быть запущен скрипт для наполнения масива текстовых привязок CrossReference Destinations for DrugDescription Set  version 1.0
//
// CrossReference Sources for DrugDescription Set version 1.0.jsx
//
// Modified 2018-04-19
// Igor Nikitin, Rls
// 
//
// List of things required for the script to run

//Main();
// If you want the script to be un-doable, comment out the line above, and remove the comment from the line below
app.doScript(Main, undefined, undefined, UndoModes.ENTIRE_SCRIPT,"Run Script");

function Main() {
	// Check to see whether any InDesign documents are open.
	// If no documents are open, display an error message.
	if (app.documents.length > 0) {
    var workXmlElement;
    var targetHref;
    var doc = app.activeDocument; 
    var dstDoc = app.documents.itemByName('Glava_1_5_1_currentTestXML.indd'); // документ с разделом "Описания лекарственных средств" - необходимо подставить АКТУАЛЬНОЕ имя файла
    var xmlRoot = doc.xmlElements[0];  
    var mySetDest = dstDoc.hyperlinkTextDestinations; //массив текстовых привязок документа
    var storeDestinationNames = {}; 
    for (var i = 0; i < mySetDest.length; i++) { // производится наполнение объекта с ключами, взятыми из имен элементов массива текстовых привязок
      var key = mySetDest[i].name;   //для последующего быстрого поиска по именам ключей. доступ к имена ключей осуществляется быстрее, чем перебор массива.
      storeDestinationNames[key] = i;  
    }
    var myCrossRefSrcs = doc.crossReferenceSources; // массив мест отсылок (sources) перекрестных ссылок
    var currentDest;
    var currentSource;
    var targetXPathExpression; //переменная для составления сложных XPath выражений. в этом скрипте не используется
    var textWhereToInsert;
    var xRefForm = doc.crossReferenceFormats.item("Page Number");         //определяется формат перекрестной ссылки. В самом документе необходимо проверить формат, чтобы он состоял только из <page>
    var xmlCrossRefArr = xmlRoot.evaluateXPathExpression("descendant::Brick/crossRef[@href]");//массив всех xml-элементов crossRef  в разделе "Предметный указатель"
    for (i=0; i<xmlCrossRefArr.length; i++) { //перебираем все узлы crossRef
          targetHref=xmlCrossRefArr[i].xmlAttributes[0].value;      //определяется значение единственного атрибута (href)
          if (targetHref !=='undefined' && targetHref in storeDestinationNames) { //проверка на наличие значения в объекте с ключами-именами текстовых привязок
              currentDest = mySetDest[storeDestinationNames[targetHref]]; //ссылка находит объект текстовой привязки по значению объекта storeDestinationNames с найденным ключом
              workXmlElement = xmlCrossRefArr[i];             //теперь возвращаемся к xml-элементу, содержащему crossref элемент
              textWhereToInsert = workXmlElement.texts[0];     //предполагается, что содержимое элемента состоит из пустого наполнителя 0000
              currentSource = myCrossRefSrcs.add(textWhereToInsert,xRefForm); //вместо наполнителя добавляется перекрестная ссылка
              doc.hyperlinks.add(currentSource, currentDest);                     //в массив, связывающий ссылки и тексты привязки, добавляется элемент
            } 
    }
  }
	else {
		// No documents are open, so display an error message.
		alert("No InDesign documents are open. Please open a document and try again.");
	}
}