import type { ButtonHTMLAttributes, ReactNode } from "react";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  className?: string;
}

export default function Button({
  children,
  className = "",
  ...props
}: ButtonProps) {
  return (
    <button
      className={`px-8 py-3 rounded-lg font-bold transition flex items-center justify-center focus:outline-none focus:ring-2 focus:ring-accent bg-accent text-white hover:bg-primary cursor-pointer disabled:opacity-60 disabled:cursor-not-allowed border-2 border-white shadow-lg shadow-white/20 ${className}`}
      {...props}
    >
      {children}
    </button>
  );
}
