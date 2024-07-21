import React, { useRef } from 'react';
import imageCompression from 'browser-image-compression';
import { Dropbox } from 'dropbox';

const App = () => {
  const captureRef = useRef(null);
  const previewRef = useRef(null);

  const handleCaptureChange = async (e) => {
    const file = e.target.files[0];
    const reader = new FileReader();

    reader.onloadend = function() {
      const imageData = reader.result;
      previewRef.current.src = imageData;
      previewRef.current.style.display = 'block';
    };

    reader.readAsDataURL(file);

    // Compress image
    const options = {
      maxSizeMB: 2,
      maxWidthOrHeight: 2000,
      useWebWorker: true,
    };

    try {

      const compressedFile = await imageCompression(file, options);
      const accessToken = process.env.REACT_APP_DROPBOX_ACCESS_TOKEN;
      const dbx = new Dropbox({ accessToken });

      console.log('Access Token', accessToken);
      // Convert compressedFile to Blob
      const blob = new Blob([compressedFile], { type: compressedFile.type });

      const response = await dbx.filesUpload({
        path: `/${compressedFile.name}`,
        contents: blob,
        mode: 'add',
        autorename: true,
        mute: false,
      });

      console.log('File uploaded successfully!', response);
      alert('File uploaded successfully!');
    } catch (error) {
      console.error('Error uploading file to Dropbox:', error);
      alert('Error uploading file to Dropbox.');
    }
  };

  const handleSendButtonClick = () => {
    captureRef.current.click();
  };

  return (
    <div className="App">
      <h1>Upload Image to Dropbox</h1>
      <input
        type="file"
        id="capture"
        ref={captureRef}
        style={{ display: 'none' }}
        onChange={handleCaptureChange}
      />
      <button id="send" onClick={handleSendButtonClick}>
        Send
      </button>
      <img id="preview" ref={previewRef} style={{ display: 'none' }} alt="Preview" />
    </div>
  );
};

export default App;