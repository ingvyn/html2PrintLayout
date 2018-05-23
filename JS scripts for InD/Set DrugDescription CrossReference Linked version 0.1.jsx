//DESCRIPTION:makes cross-referenced elements with child crossRef node and elements with child anchorCR node if values of their attributes href and name are equal
//автоматически генерирует перекрестные ссылки между элементами в xml-представлении макета главы Описание лекарств Энциклопедии РЛС, у которых имеются дочерние элементы crossRef и anchorCR и их атрибуты href и name имеют одинаковые численные значения
// Set DrugDesription Stuff CrossReference Linked.jsx в отличии от версии 20.03.18 расставляет перекрестные ссылки прямо внутри элементов crossRef. Скрипт писался для макета, в котором после текста, за которым должны быть проставлены пер. ссылки, уже стоят необходимые знаки (табуляция или запятая-пробел или перевод строки), а в элементах crossRef проставлены текстовые наполнители 0000.
//Скрипт от 20.03.18 расставляет перекрестные сслыки в конце тестовых абзацев, заключенных в элементах, являющихся родителями crossRef
// Modified 2018-04-18
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
    var xmlRoot = doc.xmlElements[0];  
    var xmlCrossRefArr = xmlRoot.evaluateXPathExpression("//crossRef");//массив всех xml-элементов crossRef
    var xmlAnchorRefArr = []; //можно закомментировать
    var mySetDest = doc.hyperlinkTextDestinations;
    var myCrossRefSrcs = doc.crossReferenceSources;
    var currentDest;
    var currentSource;
    var targetXPathExpression;
    var textWhereToInsert;
    var xRefForm = doc.crossReferenceFormats.item("Page Number");                               //определяется формат перекрестной ссылки
    for (var i=0; i<xmlCrossRefArr.length; i++) { //перебираем все узлы, имеющие элементы crossRef
          targetHref=xmlCrossRefArr[i].xmlAttributes[0].value;                        //определяется значение единственного атрибута (href)
          if (targetHref !=='undefined') {
            targetXPathExpression="//anchorCR[@name= " + targetHref + "]";            //формируем XPath выражение для поиска элементов anchorCR с тем же самым значение единственного атрибута name
            xmlAnchorRefArr = xmlRoot.evaluateXPathExpression(targetXPathExpression); //массив найденных элементов: по смыслу должен быть единственный элемент, удовлетворяющий условию
            if (xmlAnchorRefArr.length > 0) {
              workXmlElement= xmlAnchorRefArr[0].parent;                              //переходим к родителю элемента 
              currentDest = mySetDest.add(workXmlElement.texts[0]);                //текст элемента добавляется в массив-свойство активного документа, состоящий из текстов-привязок
              currentDest.name = targetHref;                                      //свойству-имени текста привязки  присваивается присваивается уникальное имя, в данном случае значение атрибута, по которому мы искали элемент текущий элемент anchorCR
              workXmlElement = xmlCrossRefArr[i];             //теперь возвращаемся к xml-элементу, содержащему crossref элемент, по атрибуту котрого мы находили соотв. элемент anchorCR
              textWhereToInsert = workXmlElement.texts[0];     //предполагается, что содержимое элемента состоит из пустого наполнителя 0000
              currentSource = myCrossRefSrcs.add(textWhereToInsert,xRefForm); //после добавляется перекрестная ссылка
              doc.hyperlinks.add(currentSource, currentDest);                     //в массив, связывающий ссылки и тексты привязки, добавляется элемент
            } 
          }
    }
        
   
    }
	else {
		// No documents are open, so display an error message.
		alert("No InDesign documents are open. Please open a document and try again.");
	}
}