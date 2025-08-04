import os
import pandas as pd

def concatenate_excels(input_folder, output_file):
    excel_files = [f for f in os.listdir(input_folder) if f.endswith('.xlsx') ]
    dfs = []
    for file in excel_files:
        file_path = os.path.join(input_folder, file)
        df = pd.read_excel(file_path)
        dfs.append(df)
    concatenated_df = pd.concat(dfs, ignore_index=True)
    concatenated_df.to_excel(output_file, index=False)

def autosize_excel_columns(output_file):
    from openpyxl import load_workbook
    wb = load_workbook(output_file)
    ws = wb.active
    for column in ws.columns:
        max_length = 0
        column_letter = column[0].column_letter
        for cell in column:
            try:
                if cell.value:
                    max_length = max(max_length, len(str(cell.value)))
            except:
                pass
        adjusted_width = (max_length + 2)
        ws.column_dimensions[column_letter].width = adjusted_width
    wb.save(output_file)

if __name__ == "__main__":
    input_folder = "C:\\Artefactos\\Aplicaciones IIS"
    output_file = "C:\\Artefactos\\Aplicaciones IIS\\archivo_concatenado.xlsx"
    concatenate_excels(input_folder, output_file)
    autosize_excel_columns(output_file)
    print(f"Archivos concatenados y guardados en: {output_file}")