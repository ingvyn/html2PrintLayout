//DESCRIPTION:makes cross-referenced elements with child crossRef node and elements with child anchorCR node if values of their attributes href and name are equal
//автоматически генерирует перекрестные ссылки между элементами в xml-представлении макета главы Описание лекарств Энциклопедии РЛС, у которых имеются дочерние элементы crossRef и anchorCR и их атрибуты href и name имеют одинаковые численные значения
// Set DrugDesription CrossReference Linked.jsx
//
// Modified 2018-03-16
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
    var xmlParentOfCrossRefArr = xmlRoot.evaluateXPathExpression("descendant::*[crossRef]"); //массив всех родителей xml-элементов crossRef
    var xmlCrossRefArr = [];//массив xml-элементов crossRef, имеющих одного родителя
    var xmlAnchorRefArr = []; //можно закомментировать
    var mySetDest = doc.hyperlinkTextDestinations;
    var myCrossRefSrcs = doc.crossReferenceSources;
    var currentDest;
    var currentSource;
    var targetXPathExpression;
    var paragraphWhereToInsert;
    var xRefForm = doc.crossReferenceFormats.item("Page Number");                               //определяется формат перекрестной ссылки
    for (var parentCounter=0; parentCounter<xmlParentOfCrossRefArr.length; parentCounter++) { //перебираем все узлы, имеющие элементы crossRef
      xmlCrossRefArr = xmlParentOfCrossRefArr[parentCounter].evaluateXPathExpression("child::crossRef"); //формируем массив для перебора всх crossRef элементов, имеющих одного родителя (в общем случае crossref элементов может быть не один, а несколько)
      for (var i=0; i<xmlCrossRefArr.length; i++) {                                 //перебираем массив crossRef элементов, имеющих одного родителя
        targetHref=xmlCrossRefArr[i].xmlAttributes[0].value;                        //определяется значение единственного атрибута (href)
        if (targetHref !=='undefined') {
          targetXPathExpression="//anchorCR[@name= " + targetHref + "]";            //формируем XPath выражение для поиска элементов anchorCR с тем же самым значение единственного атрибута name
          xmlAnchorRefArr = xmlRoot.evaluateXPathExpression(targetXPathExpression); //массив найденных элементов: по смыслу должен быть единственный элемент, удовлетворяющий условию
          if (xmlAnchorRefArr.length > 0) {
            workXmlElement= xmlAnchorRefArr[0].parent;                              //переходим к родителю элемента 
            currentDest = mySetDest.add(workXmlElement.texts[0]);                //текст элемента добавляется в массив-свойство активного документа, состоящий из текстов-привязок
            currentDest.name = targetHref;                                      //свойству-имени текста привязки  присваивается присваивается уникальное имя, в данном случае значение атрибута, по которому мы искали элемент текущий элемент anchorCR
            workXmlElement = xmlParentOfCrossRefArr[parentCounter];             //теперь возвращаемся к xml-элементу, содержащему crossref элемент, по атрибуту котрого мы находили соотв/ элемент anchorCR
            paragraphWhereToInsert = workXmlElement.paragraphs.firstItem();     //предполагается, что содержимое элемента состоит из одного параграфа
            if (i===0) {                                                        // и мы добавляем, если у нас одна перекрестная ссылка, а в дереве у родителя один crossRef элемент, табуляцию
              paragraphWhereToInsert.insertionPoints.item(-2).contents = "\t"; //позиция -2 соответствует позиции до перевода строки
            } else {                                                           // за первой перекрестной ссылкой, если есть последующие, запятую и пробел
              paragraphWhereToInsert.insertionPoints.item(-2).contents = ", ";
            }
            currentSource = myCrossRefSrcs.add(paragraphWhereToInsert.insertionPoints.item(-2),xRefForm); //после добавляется перекрестная ссылка
            doc.hyperlinks.add(currentSource, currentDest);                     //в массив, связывающий ссылки и тексты привязки, добавляется элемент
          }
        }
      }
    }
        
   
    }
	else {
		// No documents are open, so display an error message.
		alert("No InDesign documents are open. Please open a document and try again.");
	}
}