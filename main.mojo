from python import Python
from time import now
from extractor.extract import PDFImageExtractor, PDFPageToImageConverter

fn main() raises:
    try:
        var timestamp = str(now())
        print("Starting PDF processing at ", timestamp)

        var args = Python.import_module("sys").argv
        var default_path = "./extract/target.pdf"
        var pdf_path: String

        if len(args) > 1:
            pdf_path = str(args[1])
        else:
            pdf_path = default_path

        print("Processing:", pdf_path)

        var extractor = PDFImageExtractor()
        var converter = PDFPageToImageConverter()
        var extract_count = extractor.extract_images(pdf_path)
        var convert_count = converter.convert_pages(pdf_path)

        print("\nExtracted", extract_count, "images")
        extractor.print_extracted_files()

        print("\nConverted", convert_count, "pages")
        converter.print_converted_files()

        print("\nProcessing complete!")
    except:
        print("Error processing PDF. Please check the file exists and is readable.")
