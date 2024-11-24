# PDF Extract
Extract text, embedded images and convert pages to images from PDFs using Mojo.

## Requirements
- Mojo
- Magic environment with:
  - pdfplumber
  - pdf2image

## Setup
```bash
# Install dependencies
magic add "pdfplumber"
magic add "pdf2image"
```

## Usage
```bash
magic shell

# Converts ./extract/target.pdf:
mojo main.mojo

# Or specify a different path:
mojo main.mojo --pdf=/path/to/your.pdf
```

## Output
- Extracted text will be in `extracted_text/`
- Extracted images will be in `extracted_images/`
- Converted page images will be in `converted_images/`
