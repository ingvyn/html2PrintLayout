//DESCRIPTION:
//Для  главы описаний Энциклопедии лекарств осуществляется поиск всех xml-элементов anchorCR c атрибутом name. Текст из родителей этих элементов заносится в массив тестовых привязок этого активного документа. 
// CrossReference Destinations for DrugDescription Set  version 1.0.jsx
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
    var doc = app.activeDocument;  
    var xmlRoot = doc.xmlElements[0];  
    var xmlAnchorRefArr = xmlRoot.evaluateXPathExpression("descendant::OPIS_LARGETON/descendant::anchorCR[@name] | descendant::Opis_DV_Opis/descendant::anchorCR[@name] ");//массив всех xml-элементов аnchorCR для главы Описания лекарств. Для этой главы они расположены под элементами OPIS_LARGETON и Opis_DV_Opis
    var mySetDest = doc.hyperlinkTextDestinations;
    var currentName;
    var currentDest;
    for (var i=0; i<xmlAnchorRefArr.length; i++) { //перебираем все узлы, имеющие элементы anchorCR
      currentName = xmlAnchorRefArr[i].xmlAttributes[0].value; 
      workXmlElement= xmlAnchorRefArr[i].parent;                              //переходим к родителю элемента 
      currentDest = mySetDest.add(workXmlElement.texts[0]);                //текст элемента добавляется в массив-свойство активного документа, состоящий из текстов-привязок
      currentDest.name = currentName;                                      //свойству-имени текста привязки  присваивается присваивается уникальное имя, в данном случае значение атрибутата name элемента anchorCR
    }
	}
	else {
		// No documents are open, so display an error message.
		alert("No InDesign documents are open. Please open a document and try again.");
	}
}   