//DESCRIPTION:
//Скрипт осуществляет простановку перекрестных ссылок для главы "Описания л.с., БАДов, мед. изд." в разделах 1.4-1.5 при условии, что в InDesign открыты файлы Glava_1_4.indd (разделы 1.4) и Glava_1_5.indd (раздел 1.5). Ссылки проставляются при условии, что xml-элементы, связанные с макетом, которые должны стать sources перекрестных ссылок, содержат дочерние элементы anchorCR, а xml-элементы, соотв. элементам макета, которые должны быть якорями перекрестных сслыок, соедржат дочерние элементы crossRef.
// CrossReference for DrugDescription Set  version 1.0.jsx
//
// Modified 2019-04-10
// Igor Nikitin, Rls
//
//

//Main();
// If you want the script to be un-doable, comment out the line above, and remove the comment from the line below
app.doScript(Main, undefined, undefined, UndoModes.ENTIRE_SCRIPT, 'Run Script');

function Main() {
  // установка переменной-ссылки на документ "Предметный указатель (раздел 1.4)" главы "Описания л.с., БАДов, мед. изд."
  var doc1 = app.documents.itemByName('Glava_1_4.indd');
  //установка переменной-ссылки на документ, содержащий одноименный раздел "Описания л.с., БАДов, мед. изд." (раздел 1.5) главы "Описания л.с., БАДов, мед. изд."
  var doc2 = app.documents.itemByName('Glava_1_5.indd');

  try {
    if (!(doc1.name && doc2.name)) {
      throw new ReferenceError('Ошибка чтения данных');
    }
  } catch (e) {
    if (e.name == 'ReferenceError') {
      alert(
        'Для работы скрипта необходимо открыть документы Glava_1_4.indd, Glava_1_5.indd. Откройте их и запустите скрипт снова'
      );
      return;
    } else {
      throw e;
    }
  }
  //объявление объекта с ключами, взятыми из имен элементов массива текстовых привязок документа doc2, для осуществления быстрого поиска по именам
  var storeDrugDescriptionDestinationNames = allDestinationNamesForDocument(
    doc2
  );

  //установка номеров страниц перекрестных ссылок в "Предметном указателе" (стиль абзацев и соотв. xml-элементов Puk_Preparat и PUK_DVName)
  setSourcesForDocument(
    doc1,
    doc2,
    storeDrugDescriptionDestinationNames,
    'descendant::Puk_Preparat/descendant::crossRef[@href] | descendant::PUK_DVName/descendant::crossRef[@href]'
  );
  //установка номеров страниц перекрестных ссылок в "Описания л.с., БАДов, мед. изд." (стиль абзацев и соотв. xml-элементов OPIS_DV и Opis_Synonym_ZAK)
  setSourcesForDocument(
    doc2,
    doc2,
    storeDrugDescriptionDestinationNames,
    'descendant::OPIS_DV/descendant::crossRef[@href] | descendant::Opis_Synonym_ZAK/descendant::crossRef[@href]'
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
