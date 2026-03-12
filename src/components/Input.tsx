import { type InputHTMLAttributes } from "react";

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  className?: string;
}

export default function Input({ label, className = "", ...props }: InputProps) {
  return (
    <div className="flex flex-col gap-1 w-full">
      {label && (
        <label className="text-sm font-medium mb-1 text-white">{label}</label>
      )}
      <input
        className={`px-4 py-3 rounded bg-background border-2 border-white shadow-lg shadow-white/10 text-white focus:outline-none focus:ring-2 focus:ring-accent placeholder:text-gray-400 ${className}`}
        style={{ cursor: "text" }}
        {...props}
      />
    </div>
  );
}
