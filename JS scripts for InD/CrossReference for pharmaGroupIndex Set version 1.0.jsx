//DESCRIPTION:
//Скрипт осуществляет простановку перекрестных ссылок для главы "Фармакологический указатель" в разделах 2.1-2.3 и 2.4 при условии, что в InDesign открыты файлы Glava_2_1.indd (разделы 2.1-2.3) и Glava_2_2.indd (раздел 2.4), а также файл главы описаний Glava_1_5.indd. Ссылки проставляются при условии, что xml-элементы, связанные с макетом, которые должны стать sources перекрестных ссылок, содержат дочерние элементы anchorCR, а xml-элементы, соотв. элементам макета, которые должны быть якорями перекрестных сслыок, соедржат дочерние элементы crossRef.
// CrossReference for pharmaGroupIndex Set  version 1.0.jsx
//
// Modified 2019-03-14
// Igor Nikitin, Rls
//
//

//Main();
// If you want the script to be un-doable, comment out the line above, and remove the comment from the line below
app.doScript(Main, undefined, undefined, UndoModes.ENTIRE_SCRIPT, 'Run Script');

function Main() {
  // Check to see whether any InDesign documents are open.
  // If no documents are open, display an error message.

  // установка переменной-ссылки на документ, содержащий раздел "Описания л.с. ..." из главы описаний
  var doc0 = app.documents.itemByName('Glava_1_5.indd');
  // установка переменной-ссылки на документ-введение, предваряющий "Фармакологический указатель" и содержащий основной перечень, алфавитный перечень и классификацию фарм. групп
  var doc1 = app.documents.itemByName('Glava_2_1.indd');
  //установка переменной-ссылки на документ, содержащий раздел "Фармакологический указатель" из главы "Фармакологический указатель"
  var doc2 = app.documents.itemByName('Glava_2_2.indd');
  //объявление объекта с ключами, взятыми из имен элементов массива текстовых привязок документа doc0, для осуществления быстрого поиска по именам
  try {
    if (!(doc0.name && doc1.name && doc2.name)) {
      throw new ReferenceError('Ошибка чтения данных');
    }
  } catch (e) {
    if (e.name == 'ReferenceError') {
      alert(
        'Для работы скрипта необходимо открыть документы Glava_1_5.indd, Glava_2_1.indd, Glava_2_2.indd. Откройте все три документа и запустите скрипт снова'
      );
      return;
    } else {
      throw e;
    }
  }
  var storeDrugDescriptionDestinationNames = allDestinationNamesForDocument(
    doc0
  );
  //объявление объекта с ключами, взятыми из имен элементов массива текстовых привязок документа doc2,  для осуществления быстрого поиска по именам
  var storePharmGrIndexDestinationNames = allDestinationNamesForDocument(doc2);
  //установка номеров страниц перекрестных ссылок в Перечне основных фармакологических групп (стиль абзацев и соотв. xml-элементов MainFG)
  setSourcesForDocument(
    doc1,
    doc2,
    storePharmGrIndexDestinationNames,
    'descendant::MainFG/descendant::crossRef[@href]'
  );
  //установка номеров страниц перекрестных ссылок в Классификации фармакологических групп (стиль абзацев и соотв. xml-элементов ClFG_FG1, ClFG_FG2,ClFG_FG3,ClFG_FG4,ClFG_FG5)
  setSourcesForDocument(
    doc1,
    doc2,
    storePharmGrIndexDestinationNames,
    'descendant::*[contains(name(), "ClFG_FG")]/descendant::crossRef[@href]'
  );
  //установка номеров страниц перекрестных ссылок в Алфавитном перечне фармакологических групп и подгрупп (стиль абзацев и соотв. xml-элементов AlPer_FG)
  setSourcesForDocument(
    doc1,
    doc2,
    storePharmGrIndexDestinationNames,
    'descendant::AlPer_FG/descendant::crossRef[@href]'
  );
  //установка номеров страниц перекрестных ссылок в Указателе л.с. и д.в. по фармакологическим группам (стиль абзацев и соотв. xml-элементов UkFG_Tname, UkFG_DV); поиск якорей для этих ссылок проводится в файле раздела главы 1 "Описания л.с., БАДов, мед. изделий"
  setSourcesForDocument(
    doc2,
    doc0,
    storeDrugDescriptionDestinationNames,
    'descendant::UkFG_TName/descendant::crossRef[@href] | descendant::UkFG_DV/descendant::crossRef[@href]'
  );

  return;

  function allDestinationNamesForDocument(doc) {
    //формирование объекта с ключами из имен объектов привязки документа
    var key;
    var storeDestinationNames = {};
    if (doc.hyperlinkTextDestinations.length === 0) {
      //массив текстовых привязок документа
      setDestinationForDocument(doc); // если в документе нет текстовых привязок, управление забирает функция, проставляющая их
    }
    for (var i = 0; i < doc.hyperlinkTextDestinations.length; i++) {
      // производится наполнение объекта с ключами, взятыми из имен элементов массива текстовых привязок
      key = doc.hyperlinkTextDestinations[i].name; //для последующего быстрого поиска по именам ключей. доступ к имена ключей осуществляется быстрее, чем перебор массива.
      storeDestinationNames[key] = i;
    }
    return storeDestinationNames;
  }

  function setDestinationForDocument(doc) {
    // поиск всех xml-элементов anchorCR c атрибутом name. Текст из родителей этих элементов заносится в массив тестовых привязок этого активного документа
    var xmlRoot = doc.xmlElements[0];
    var xmlAnchorRefArr = xmlRoot.evaluateXPathExpression(
      'descendant::anchorCR[@name]'
    );
    var iteratedNodesValues = {};
    var mySetDest = doc.hyperlinkTextDestinations;
    var currentName;
    var currentDest;
    for (var i = 0; i < xmlAnchorRefArr.length; i++) {
      //перебираем все узлы, имеющие элементы anchorCR
        currentName = xmlAnchorRefArr[i].xmlAttributes[0].value; //берется значение единственного атрибута name
        if (!(currentName in iteratedNodesValues)) { //только если такое же значение еще не обрабатывалось
            workXmlElement = xmlAnchorRefArr[i].parent; //переходим к родителю элемента
            currentDest = mySetDest.add(workXmlElement.texts[0]); //текст элемента добавляется в массив-свойство активного документа, состоящий из текстов-привязок
            currentDest.name = currentName; //свойству-имени текста привязки  присваивается присваивается уникальное имя, в данном случае значение атрибутата name элемента anchorCR
        }
        iteratedNodesValues[currentName] = i; // значение сохраняется для последующей проверки на уникальность
    }
  }

  // функция проставляет ссылки с номерами страниц в документе srcDoc, используя в качестве аргументов ссылку на документ dstDoc с якорями (привязками destinations) для перекрестных ссылок, используя объект с именами текстовых привязок в dstDoc, XPath выражение для поиска элементов croosRef с наполнителями 0000, на место которых функция должна вставить номера страниц перекрестных ссылок
  function setSourcesForDocument(
    srcDoc,
    dstDoc,
    objectForDestinationSearch,
    xpathExpression
  ) {
    var currentDest;
    var currentSource;
    var targetHref;
    var textWhereToInsert;
    var xRefForm = srcDoc.crossReferenceFormats.item('Page Number'); //определяется формат перекрестной ссылки. В самом документе необходимо проверить формат, чтобы он состоял только из <page>
    var xmlRoot = srcDoc.xmlElements[0];
    var xmlCrossRefArr = xmlRoot.evaluateXPathExpression(xpathExpression);
    for (i = 0; i < xmlCrossRefArr.length; i++) {
      targetHref = xmlCrossRefArr[i].xmlAttributes[0].value; //определяется значение единственного атрибута (href)
      if (
        targetHref !== 'undefined' &&
        targetHref in objectForDestinationSearch
      ) {
        currentDest =
          dstDoc.hyperlinkTextDestinations[
            objectForDestinationSearch[targetHref]
          ]; //ссылка находит объект текстовой привязки по значению объекта objectForDestinationSearch с найденным ключом
        textWhereToInsert = xmlCrossRefArr[i].texts[0]; //предполагается, что содержимое элемента состоит из пустого наполнителя 0000
        currentSource = srcDoc.crossReferenceSources.add(
          textWhereToInsert,
          xRefForm
        ); //вместо наполнителя добавляется перекрестная ссылка
        srcDoc.hyperlinks.add(currentSource, currentDest); //в массив, связывающий ссылки и тексты привязки, добавляется элемент
      }
    }
  }
}
