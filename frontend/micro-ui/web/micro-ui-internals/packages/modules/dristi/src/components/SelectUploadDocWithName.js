import React, { useMemo, useState } from "react";
import { Button, TextInput } from "@egovernments/digit-ui-react-components";
import CustomErrorTooltip from "./CustomErrorTooltip";
import { FileUploader } from "react-drag-drop-files";
import RenderFileCard from "./RenderFileCard";
import { ReactComponent as DeleteFileIcon } from "../images/delete.svg";

import { UploadIcon } from "@egovernments/digit-ui-react-components";

function SelectUploadDocWithName({ t, config, formData = {}, onSelect }) {
  const [documentData, setDocumentData] = useState([]);

  const inputs = useMemo(
    () =>
      config?.populators?.inputs || [
        {
          label: "label",
          type: "text",
          name: "docName",
          validation: {
            pattern: /^[^{0-9}^\$\"<>?\\\\~!@#$%^()+={}\[\]*,/_:;“”‘’]{1,50}$/i,
            errMsg: "CORE_COMMON_DOCUMENT_NAME_INVALID",
            title: "",
            patternType: "Name",
            isRequired: true,
          },
          isMandatory: true,
        },
        {
          isMandatory: true,
          name: "document",
          documentHeader: "header",
          type: "DragDropComponent",
          maxFileSize: 50,
          maxFileErrorMessage: "CS_FILE_LIMIT_50_MB",
          fileTypes: ["JPG", "PNG", "PDF"],
          isMultipleUpload: false,
        },
      ],
    [config?.populators?.inputs]
  );

  const dragDropJSX = (
    <div className="drag-drop-container">
      <UploadIcon />
      <p className="drag-drop-text">
        {t("WBH_DRAG_DROP")} <text className="browse-text">{t("WBH_BULK_BROWSE_FILES")}</text>
      </p>
    </div>
  );

  const handleFileChange = (file, input, index) => {
    let currentDocumentDataCopy = structuredClone(documentData);
    let currentDataObj = currentDocumentDataCopy[index];
    currentDataObj.document = [file];
    currentDocumentDataCopy.splice(index, 1, currentDataObj);
    setDocumentData(currentDocumentDataCopy);
    onSelect(config.key, currentDocumentDataCopy);
  };

  const handleDeleteFile = (index) => {
    let currentDocumentDataCopy = structuredClone(documentData);
    let currentDataObj = currentDocumentDataCopy[index];
    currentDataObj.document = [];
    currentDocumentDataCopy.splice(index, 1, currentDataObj);
    setDocumentData(currentDocumentDataCopy);
    onSelect(config.key, currentDocumentDataCopy);
  };

  const fileValidator = (file, input) => {
    const maxFileSize = input?.maxFileSize * 1024 * 1024;
    if (file.length > 0) {
      return file[0].size > maxFileSize ? t(input?.maxFileErrorMessage) : null;
    } else return null;
  };

  const handleAddDocument = () => {
    const documentDataCopy = structuredClone(documentData);
    const dataObject = {
      docName: "",
      document: [],
    };
    documentDataCopy.push(dataObject);
    setDocumentData(documentDataCopy);
    onSelect(config.key, documentDataCopy);
  };

  const handleDeleteDocument = (index) => {
    let currentDocumentDataCopy = structuredClone(documentData);
    currentDocumentDataCopy.splice(index, 1);
    setDocumentData(currentDocumentDataCopy);
    onSelect(config.key, currentDocumentDataCopy);
  };

  const handleOnTextChange = (value, input, index) => {
    let currentDocumentDataCopy = structuredClone(documentData);
    let currentDataObj = currentDocumentDataCopy[index];
    currentDataObj[input.name] = value;
    currentDocumentDataCopy.splice(index, 1, currentDataObj);
    setDocumentData(currentDocumentDataCopy);
    onSelect(config.key, currentDocumentDataCopy);
  };

  return (
    <div>
      <div style={{ marginTop: "20px" }}>
        {documentData.length > 0 &&
          documentData.map((data, index) => {
            return (
              <div key={index} style={{ border: "solid 1px #BBBBBD" }}>
                <div style={{ display: "flex", justifyContent: "space-between", borderBottom: "solid 1px #BBBBBD" }}>
                  <h1>{`${t("DOCUMENT_NUMBER_HEADING")} ${documentData.length}`}</h1>
                  <Button
                    onButtonClick={() => {
                      handleDeleteDocument(index);
                    }}
                    icon={
                      <div>
                        <DeleteFileIcon />
                      </div>
                    }
                    className="delete-button"
                    label={t("Delete")}
                  />
                </div>
                <div style={{ padding: "0px 5px 10px 5px" }}>
                  {inputs.map((input) => {
                    let currentValue = data && data[input.name];
                    if (input.type === "text") {
                      return (
                        <div>
                          <h1>{t("DOCUMENT_NAME_TITLE")}</h1>
                          <TextInput
                            className="field desktop-w-full"
                            key={input?.name}
                            value={currentValue}
                            onChange={(e) => {
                              handleOnTextChange(e.target.value, input, index);
                            }}
                            disable={input?.isDisabled}
                            defaultValue={undefined}
                            {...input?.validation}
                          />
                        </div>
                      );
                    } else {
                      let fileErrors = fileValidator(currentValue, input);
                      const showFileUploader = currentValue.length ? input?.isMultipleUpload : true;
                      return (
                        <div className="drag-drop-visible-main">
                          <div className="drag-drop-heading-main">
                            <div className="drag-drop-heading">
                              <span>
                                <h2 className="card-label">{t(input?.documentHeader)}</h2>
                              </span>
                            </div>
                          </div>
                          {currentValue.length > 0 && (
                            <RenderFileCard
                              fileData={currentValue[0]}
                              handleChange={(data) => {
                                handleFileChange(data, input, index);
                              }}
                              handleDeleteFile={() => handleDeleteFile(index)}
                              t={t}
                              uploadErrorInfo={fileErrors}
                              input={input}
                            />
                          )}
                          {showFileUploader && (
                            <div>
                              <FileUploader
                                handleChange={(data) => {
                                  handleFileChange(data, input, index);
                                }}
                                name="file"
                                types={input?.fileTypes}
                                children={dragDropJSX}
                                key={input?.name}
                              />
                            </div>
                          )}
                        </div>
                      );
                    }
                  })}
                </div>
              </div>
            );
          })}
      </div>
      {<span onClick={handleAddDocument}> + Add Document</span>}
    </div>
  );
}

export default SelectUploadDocWithName;